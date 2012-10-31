module Filters
  class LeadFilter < WillFilter::Filter
    def model_class
      Lead
    end

    def definition
      defs = super
      defs[:status][:is] = :list
      defs[:status][:is_not] = :list
      defs[:account_id][:is] = :list
      defs[:account_id][:is_not] = :list
      defs
    end

    def value_options_for(condition_key)
      case condition_key
        when :status
          %W{new attention_needed waiting_reply posponed discarted}
        when :account_id
          {1 => "Mercedes", 2 => "Patico"}
        else
          []
      end
    end

    def condition_title_for(key)
      return 'Account' if key == :account_id
      super
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