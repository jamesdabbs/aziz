class ImpositionsController < ApplicationController
  def new
    @imposition = Imposition.new
  end

  def create
    @imposition = Imposition.new create_params.merge(metadata: request_metadata)
    if @imposition.save
      redirect_to new_imposition_path, success: "Got it! Sorry about that!"
    else
      render :new
    end
  end

  private

  def create_params
    params.require(:imposition).permit(:body)
  end

  def request_metadata
    {
      ip:         request.remote_ip,
      user_agent: request.user_agent
    }
  end
end
