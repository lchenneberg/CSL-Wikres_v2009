class SkillsController < ApplicationController
  before_filter :login_required
  # GET /skills
  # GET /skills.xml
  def index
    @skills = Skills.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @skills }
    end
  end

  # GET /skills/1
  # GET /skills/1.xml
  def show
    @skills = Skills.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @skills }
    end
  end

  # GET /skills/new
  # GET /skills/new.xml
  def new
    @skills = Skills.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @skills }
    end
  end

  # GET /skills/1/edit
  def edit
    @skills = Skills.find(params[:id])
  end

  # POST /skills
  # POST /skills.xml
  def create
    @skills = Skills.new(params[:skills])

    respond_to do |format|
      if @skills.save
        flash[:notice] = 'Skills was successfully created.'
        format.html { redirect_to(@skills) }
        format.xml  { render :xml => @skills, :status => :created, :location => @skills }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @skills.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /skills/1
  # PUT /skills/1.xml
  def update
    @skills = Skills.find(params[:id])

    respond_to do |format|
      if @skills.update_attributes(params[:skills])
        flash[:notice] = 'Skills was successfully updated.'
        format.html { redirect_to(@skills) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @skills.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /skills/1
  # DELETE /skills/1.xml
  def destroy
    @skills = Skills.find(params[:id])
    @skills.destroy

    respond_to do |format|
      format.html { redirect_to(skills_url) }
      format.xml  { head :ok }
    end
  end
end
