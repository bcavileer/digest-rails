require_dependency "page/all_controller"

module Pane
  class MainController < Page::AllController

      def add_main_pane_rendering(pane_content)
        {
            main_pane: "MainPPPane"#get_partial(:main_pane,pane_content)
        }
      end

      def render_for_content(pane_content)
        render_for_main_pane(
            add_main_pane_rendering(pane_content)
        )
      end

  end
end