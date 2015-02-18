require_dependency "pane/main_controller"

class DigestController < Pane::MainController

  def show
    @active_digest_index = params[:digest_index].to_i
    @active_digest = @digests[@active_digest_index]
  end

end