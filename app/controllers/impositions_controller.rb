class ImpositionsController < ApplicationController
  def new
    @imposition = Imposition.new
  end

  def create
    @imposition = Imposition.create! create_params.merge(metadata: request_metadata)
    @imposition.notify!
    head :no_content
  end

  private

  def create_params
    params.require(:imposition).permit(:contact, :body)
  end

  def request_metadata
    {
      ip:         request.remote_ip,
      user_agent: request.user_agent
    }
  end
end
