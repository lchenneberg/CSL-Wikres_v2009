class ActionController::Base
  include WsAuthentication
end

class AdminController < ActionController::Base
  before_filter :check_administrator_role
  layout "application"


  
  
  def index
    #@entries = Mode.find(:all)
    @models = Dir.new("#{RAILS_ROOT}/app/models").entries.map{|model| model.camelize.gsub('.rb', '')}
    @models = @models.sort
    @models.delete('..')
    @models.delete('.')
    @models.delete_if {|model| eval("!#{model}.method_defined?(:ws_admin)")}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @models }
    end
  end

  def list
    @entries = eval("#{params[:model]}.find(:all)")
    @entries = @entries.send(:paginate, :page => params[:page], :order => 'id desc', :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @entries }
    end
  end

  def show
    @entry = eval("#{params[:model]}.find_by_id(params[:id])")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entry }
    end
  end

  def new
    @entry = eval("#{params[:model]}.new")
    @ivg = instance_variable_get("@entry")
    @fields = get_fields
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @entry }
    end
  end

  def edit
    @entry = eval("#{params[:model]}.find(params[:id])")
    @fields = get_fields
  end

  def create
    @entry = eval("#{params[:model]}.new(params[:entry])")
    @fields = get_fields
    respond_to do |format|
      if @entry.save
        flash[:notice] = "#{params[:model]} was successfully created."
        format.html { redirect_to(:action => "show", :id => @entry.id, :model => params[:model]) }
      else
        format.html { render :action => "new", :model => params[:model] }
      end
    end
  end

  def update
    @entry = eval("#{params[:model]}.find_by_id(params[:id])")

    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        flash[:notice] = "#{params[:model]} was successfully updated."
        format.html { redirect_to(:action => "show", :id => @entry.id, :model => params[:model]) }
      else
        format.html { render :action => "new", :model => params[:model], :id => params[:id] }
      end
    end
  end

  def destroy
    @entry = eval("#{params[:model]}.find_by_id(params[:id])")
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to(:controller => "admin", :action => "list", :model => params[:model]) }
      format.xml  { head :ok }
    end
  end

  private

  def get_fields
    WsForm.get_fields(params[:model])
  end

end