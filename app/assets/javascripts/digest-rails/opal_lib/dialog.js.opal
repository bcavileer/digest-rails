class Dialog < RenderTargets

    def set_content(html)
        child(:content).html(html)
    end

    def open
       `self.$button().click(function(){
          self.$parent().foundation('reveal', 'close');
        });`
        `self.$parent().foundation('reveal', 'open');`
    end

end