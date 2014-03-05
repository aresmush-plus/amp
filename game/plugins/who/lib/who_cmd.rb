module AresMUSH
  module Who
    class WhoCmd
      include AresMUSH::Plugin

      # Validators
      no_args
      no_switches
      
      def after_initialize
        header_template = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../templates/header.lq")
        char_template = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../templates/character.lq")
        footer_template = TemplateRenderer.create_from_file(File.dirname(__FILE__) + "/../templates/footer.lq")
        @renderer = WhoRenderer.new(header_template, char_template, footer_template)
      end

      def want_command?(client, cmd)
        cmd.root_is?("who")
      end
      
      def handle
        logged_in = Global.client_monitor.logged_in_clients
        # TODO - Don't hide hidden people to staff
        visible = logged_in.select { |c| !c.char.hidden }
        client.emit @renderer.render(visible)
      end      
    end
  end
end
