class SubUserController <CShopController


def index
    @ajax_search = params[:ajax_search] == "true" ? true : false
    
    #puts "sort_direction = " + sort_direction
        
    @categories = Masterusers.all

    respond_to do |format|
      format.html # index.html.erb
      format.js   # index.js.erb
      format.json { render json: @categories }
    end
  end

  # GET /categories/new
  # GET /categories/new.json
  def new
    @category = Category.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.js   # new.js.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(params[:category])
 
    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_url, flash[:info]="Category was successfully created." }
        format.js { flash[:info]="Category was successfully created." }
        format.json { render json: @category, status: :created, location: @category }
      end
    end    
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to categories_url, flash[:info]='Category was successfully updated.' }
        format.js { flash[:info]='Category was successfully updated.' }
        format.json { head :ok }        
      else
        format.html { render action: "edit" }
        format.js { flash[:error] = @comment.errors.full_messages }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    puts "DESTROY - DESTROY"
    @category = Category.find(params[:id])
    @category.destroy
    
    @categories = Category.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html { redirect_to categories_url, flash[:info]='Category was successfully deleted.'}
      format.js { flash[:info]='Category was successfully deleted.' }
      format.json { head :ok }
    end
  end




	def test
		@x = Masterusers.find_by_sql(["select * from subuser_"+session[:master_user_id].to_s])
	end
	
  
	def subuser_signup
		if params[:commit]=="signup" then
			connection = ActiveRecord::Base.connection();
			
			Masterusers.find_by_sql(["INSERT INTO subuser_"+session[:master_user_id].to_s+"(first_name,last_name,address,city,state,pincode,country,phone,subuser_email,password) VALUES (?,?,?,?,?,?,?,?,?,?)",params[:first_name], params[:last_name],params[:address], params[:city],params[:state], params[:pincode],params[:country], params[:phone],params[:subuser_email], params[:password]])                        
			redirect_to :action => 'subuser_login'
		end
	end

	def subuser_login
		if params[:commit] == "login" then
			connection = ActiveRecord::Base.connection();
			#@t= "select * from properties_" + session[:master_user_id].to_s+ " where sub_user_id = "+params[:loginid]
			member=connection.execute("select * from subuser_" + session[:master_user_id].to_s+ " where subuser_email = " +"'"+params[:email].to_s+"'")	
			
			if member != nil then
				if   member[0]["password"]==params[:password]
				session[:subuser_id]=params[:loginid]
					redirect_to :action => 'home'
				else
                    flash[:notice] = "#{'Incorrect Password details'}"        
                    redirect_to :action => 'subuser_login'
                end        
                
            else
				flash[:notice] = "#{'Invalid Email address'}"        
				redirect_to :action => 'subuser_login'
			end
		
		end
		
	end

end
