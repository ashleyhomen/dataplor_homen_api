class BirdsController < ApplicationController

  # GET /birds
  def index
    if params.key?(:node_ids)
      node_ids = params.expect(:node_ids).split(",")
      @birds = Bird.birds_of_node_descendants(node_ids)
    else
      @birds = Bird.all
    end

    render json: @birds
  end

    # Only allow a list of trusted parameters through.
    def bird_params
      params.expect(bird: [ :node_ids ])
    end
end
