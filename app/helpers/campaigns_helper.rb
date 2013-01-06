module CampaignsHelper
  def campaign_label campaign, tooltip = {}
    tooltip = {rel: 'tooltip', title: tooltip} if tooltip.kind_of? String
    options = ({class: 'label', style: "background-color: #{campaign.color}"}).merge(tooltip)

    content_tag :span, options do
      campaign.name
    end
  end
end
