class SkillsController < ApplicationController
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Skill", :skills_path
  def index
    if params[:query].present?
      @skills = Skill.where('skills.name ILIKE ?', "%#{params[:query]}%")
      @skills = @skills.or(Skill.where('skills.element_type ILIKE ?', "%#{params[:query]}%"))
      @skills = @skills.page(params[:page])
    else
      @skills = Skill.page(params[:page])
    end
  end

  def show
    @skill = Skill.find(params[:id])
    add_breadcrumb "#{@skill.name.titleize}"
  end

  def new
    add_breadcrumb "Create"
    @skill = Skill.new
  end

  def create
    @skill = Skill.new(skill_params)

    if @skill.save
      flash[:success] = "Skill successfully created!"
      redirect_to @skill
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @skill = Skill.find(params[:id])
    add_breadcrumb "Edit #{@skill.name.titleize}"
  end

  def update
    @skill = Skill.find(params[:id])

    if @skill.update(skill_params)
      flash[:success] = "Skill successfully updated!"
      redirect_to @skill
    else
      render :edit, status: :unprocessable_entity
    end


  end

  def destroy
    @skill = Skill.find(params[:id])
    @skill.destroy

    flash[:success] = "#{@skill.name.titleize} has been deleted!"
    redirect_to skills_path
  end

  private
  def skill_params
    params.require(:skill).permit(:name, :power, :max_pp, :element_type)
  end
end
