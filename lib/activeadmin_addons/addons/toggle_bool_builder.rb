module ActiveAdminAddons
  class ToggleBoolBuilder < CustomBuilder
    def render
      raise ArgumentError, 'Block should not be used in toggle bool columns' if block
      return if conditional_eval_hide?
      context.div class: 'toggle-bool-switches-container' do
        context.span toggle
      end
    end

    def toggle
      toggle_classes = 'toggle-bool-switch'
      toggle_classes += ' on' if data
      toggle_classes += ' notify-success' if options[:success_message]

      config = context.active_admin_resource_for(model.class)
      return unless config
      url = config.route_instance_path(model, {})
      byebug

      context.span(
        '',
        id: "toggle-#{class_name}-#{model.id}-#{attribute}",
        class: toggle_classes,
        'data-model' => class_name,
        'data-object_id' => model.id,
        'data-field' => attribute,
        'data-value' => data,
        'data-url' => url,
        'data-success_message' => options[:success_message]
      )
    end

    def conditional_eval_hide?
      [:if, :unless].any? do |cond|
        if options[cond]
          raise ArgumentError, "'#{cond}' option should be a proc" unless options[cond].is_a?(Proc)
          result = options[cond].call(model)
          cond == :if ? !result : result
        end
      end
    end
  end
end

ActiveAdminAddons::ToggleBoolBuilder.create_view_methods
