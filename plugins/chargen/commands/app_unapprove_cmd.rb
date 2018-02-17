module AresMUSH
  module Chargen
    class AppUnapproveCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end

      def check_permission
        return t('dispatcher.not_allowed') if !Chargen.can_approve?(enactor)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if (!model.is_approved?)
            client.emit_failure t('chargen.not_approved', :name => model.name) 
            return
          end

          model.update(is_approved: false)
          model.update(approval_job: nil)
          model.update(chargen_locked: false)
          role = Role.find_one(name: "approved")
          if (role)
            model.roles.delete role
          end
          client.emit_success t('chargen.app_unapproved', :name => model.name)
        end
      end
    end
  end
end