class QuestsController < ApplicationController
  before_action :set_quest, only: %i[ show edit update destroy ]

  # GET /quests or /quests.json
  def index
    @quests = Quest.all
  end

  # GET /quests/1 or /quests/1.json
  def show
  end

  # GET /quests/new
  def new
    @quest = Quest.new
  end

  # GET /quests/1/edit
  def edit
  end

  # POST /quests or /quests.json
  def create
    @quest = Quest.new(quest_params)
  
    respond_to do |format|
      if @quest.save
        format.turbo_stream do
          # สมมติว่าเราต้องการ clear ฟอร์มหลังบันทึกสำเร็จ
          render turbo_stream: [
            turbo_stream.prepend('quests', partial: 'quests/quest', locals: { quest: @quest }),
            turbo_stream.replace('new_quest', partial: 'quests/form', locals: { quest: Quest.new })
          ]
        end
        format.html { redirect_to quests_path, notice: 'Quest was successfully created.' }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('new_quest', partial: 'quests/form', locals: { quest: @quest })
        end
        format.html { render :new }
      end
    end
  end
  

  # PATCH/PUT /quests/1 or /quests/1.json
  def update
    respond_to do |format|
      if @quest.update(quest_params)
        format.html { redirect_to @quest, notice: "Quest was successfully updated." }
        format.json { render :show, status: :ok, location: @quest }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quests/1 or /quests/1.json
  def destroy
    @quest.destroy!

    respond_to do |format|
      format.html { redirect_to quests_path, status: :see_other, notice: "Quest was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_complete
    @quest = Quest.find(params[:id])
    @quest.update(complete: !@quest.complete)
  
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to quests_path }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quest
      @quest = Quest.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def quest_params
      params.expect(quest: [ :title, :description, :complete ])
    end
end
