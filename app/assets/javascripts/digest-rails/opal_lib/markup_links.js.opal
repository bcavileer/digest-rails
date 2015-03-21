class MarkupLinks

    def initialize
        @link_procs = []
    end

    def add_link_proc(link_proc)
        @link_procs<< link_proc
    end

    def run_link_procs
        @link_procs.each do |link_proc|
            link_proc.call()
        end
        @link_procs  = []
    end

end

