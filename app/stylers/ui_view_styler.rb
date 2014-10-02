module RubyMotionQuery
  module Stylers
    class UIViewStyler

      # Your custom styler methods here
      def border_color=(value)
        if value.is_a?(UIColor)
          @view.layer.borderColor = value.CGColor
        else
          @view.layer.borderColor = value
        end
      end

      def masks_to_bounds=(value)
        @view.layer.masksToBounds = value
      end

      def border_radius=(value)
        @view.layer.cornerRadius = value
      end

      def padding_left=(value)
        height = @view.frame.size.height
        UIView padding = UIView.alloc.initWithFrame(CGRectMake(0, 0, value, height))
        padding.opaque = false
        padding.backgroundColor = UIColor.clearColor
        @view.leftView = padding
        @view.leftViewMode = UITextFieldViewModeAlways
      end

    end
  end
end
