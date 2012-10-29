module Filters
  class LeadFilter < WillFilter::Filter
    def model_class
      Lead
    end

    def definition
      defs = super
      defs[:status][:is] = :list
      defs[:status][:is_not] = :list
      defs
    end

    def value_options_for(condition_key)
      if condition_key == :status
        return %W{new attention_needed waiting_reply posponed discarted}
      end
      return []
    end

    # What if we don’t want to allow users to have empty filters, which by default return all results.
    def x_default_filter_if_empty
      "attention_needed"
    end

    def default_filters
      [
          ["Attention Needed", "attention_needed"],
          ["Not Automatic", "not_automatic"],
          ["Last 7 days", "last_7_days"],
      ]
    end

    def default_filter_conditions(key)
      return [:status, :is, "attention_needed"] if (key == "attention_needed")
      return [ [:automatic, :is, false],[:bounce, :is, false] ] if (key == "not_automatic")
      if (key == "last_7_days")
        return [[:created, :is_in_the_range, [7.days.ago, Time.now()] ] ]
      end
    end
  end
end