module Filters
  class LeadFilter < WillFilter::Filter
    def model_class
      Lead
    end

    def definition
      defs = super
      defs[:status][:is] = :list
      defs[:status][:is_not] = :list
      defs[:stage][:is] = :list
      defs[:stage][:is_not] = :list
      defs[:account_id][:is] = :list
      defs[:account_id][:is_not] = :list
      defs
    end

    def condition_options
      {
          'Email'   => :email,  'Name'  => :first_name,
          'Status'  => :status,  'Stage' => :stage,
          'Country' => :country, 'Step' => :step,
          'Campaign'=> :campaign_id, 'Account' => :account_id
      }
    end
    def condition_optionsXXX
      %w{email first_name status stage country step campaign_id account_id}
    end

    def value_options_for(condition_key)
      case condition_key
        when :status
          Lead::STATUTES
        when :stage
          Lead::STAGES
        when :account_id
          {1 => "Mercedes", 2 => "Patico", 3 => "Fiore"}
        else
          []
      end
    end

    def condition_title_for(key)
      return 'Account' if key == :account_id
      super
    end

    # What if we don’t want to allow users to have empty filters, which by default return all results.
    def default_filter_if_empty
      "attention_needed"
    end

    def default_filters
      [
          ["Attention Needed", "attention_needed"],
          ["Waiting Reply with +2 mails", "waiting_reply_gt2"],
          ["URGENTLY", "urgently"],
          ["Customers", 'customers'],
          ["Hot Leads", 'hot_leads'],
          ["Not Automatic", "not_automatic"],
          ["Last 7 days", "last_7_days"],
      ]
    end

    def default_filter_conditions(key)
      case key
        when 'waiting_reply_gt2'
          [ [:status, :is, "waiting_reply"],[:step, :is_greater_than, 1] ]
        when 'attention_needed'
          [:status, :is, "attention_needed"]
        when 'not_automatic'
          [ [:automatic, :is, 0], [:bounce, :is, 0] ]
        when 'urgently'
          [ [:status, :is, "attention_needed"],[:step, :is_greater_than, 1] ]
        when 'customers'
          [ [:stage, :is, :customer] ]
        when 'hot_leads'
          [ [:stage, :is, :hot_lead] ]
        when 'last_7_days'
          [[:created, :is_in_the_range, [7.days.ago, Time.now()] ] ]
      end
    end
  end
end