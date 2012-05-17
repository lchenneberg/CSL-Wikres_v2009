class Accounts::MessagesController < MessagesController
  #auto_complete_for :user, :firstname, :limit => 15
  
  # GET /messages
  # GET /messages.xml
  def index
    @inbox = current_user.received_messages
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  def inbox
    @inbox = current_user.received_messages
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  def outbox
    @outbox = current_user.messages.unsent
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  def sent
    @sent = current_user.messages.sent
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  def show
    @message = Message.find(params[:id])
    @message.read!(current_user) if
      MessageRecipient.exists?(:user_id => current_user.id, :message_id => @message.id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  def new
    @message = Message.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])
    if params[:recipient_ids]
      recipients = User.find(params[:recipient_ids])
      for rec in recipients
        @message.recipients << MessageRecipient.new({:user_id => rec.id, :message_id => @message.id, :read => :false, :parent_id => current_user.id})
      end
    end

    respond_to do |format|
      if current_user.messages << @message
        if params[:sendmethod] == "Instant"
          if @message.send_message!
            flash[:notice] = "Successfully sent..."
            format.html { redirect_to sent_account_messages_url }
          else
            flash[:error] = "An error has been raised..."
          end
        else
          flash[:notice] = 'Message was successfully created.'
          format.html { redirect_to outbox_account_messages_url }
        end
        
        
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find(params[:id])
    
    respond_to do |format|
      if @message.user_id != current_user.id || @message.status == "sent"
        flash[:error] = "You haven't got right to modify this resource..."
        format.html { redirect_to account_messages_path }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      elsif @message.update_attributes(params[:message])
        flash[:notice] = 'Message was successfully updated.'
        format.html { redirect_to account_message_url(@message.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  def reply
    @original_message = Message.find(params[:id])
    @message = Message.new
  end

  def reply_action
    @original_message = Message.find(params[:id])
    @message = Message.new(params[:message])
    @message.subject = "Re: "+@original_message.subject
    
    @message.recipients << MessageRecipient.new({:user_id => @original_message.user_id, :message_id => @message.id, :read => :false, :parent_id => @original_message.id})

    respond_to do |format|
      if current_user.messages << @message
        if params[:sendmethod] == "Instant"
          if @message.send_message!
            flash[:notice] = "Successfully sent..."
            format.html { redirect_to sent_account_messages_url }
          else
            flash[:error] = "An error has been raised..."
          end
        else
          flash[:notice] = 'Message was successfully created.'
          format.html { redirect_to outbox_account_messages_url }
        end
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end


  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    if current_user.received_messages.find(@message)
      MessageRecipient.find_by_user_id_and_message_id(current_user, @message.id).destroy

    else
      @message.destroy
    end
    

    respond_to do |format|
      format.html { redirect_to account_messages_url }
      format.xml  { head :ok }
    end
  end

  def send_message
    @message = Message.find(params[:id])
    if @message.send_message!
      flash[:notice] = "Successfully sent..."
    else
      flash[:error] = "An error has been raised..."
    end
    redirect_to outbox_account_messages_url
  end

end
