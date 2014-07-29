class Builder
  def initialize(template)
    @template = ERB.new(template, nil, "-")
  end
 
  def build(page)
    context = Context.new(page)
    @template.run(context.get_binding)
  end
 
  class Context
    def initialize(page)
      @page = page.rstrip
    end
 
    def get_binding
      call_binding { @page }
    end
 
    private
 
    def call_binding
      binding
    end
  end
end