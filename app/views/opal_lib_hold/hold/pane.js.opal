class Pane

    def set_content(html)
        `$('#myModal > .content').html(html);`
        return self
    end

    def open

       ` $('a.custom-close-reveal-modal').click(function(){
          $('#myModal').foundation('reveal', 'close');
        });`

        `$('#myModal').foundation('reveal', 'open');`

    end

end