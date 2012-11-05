$ ->
  $("#scheduled_message_scheduled").datetimepicker
    timeFormat: "HH:mm:ss z"
    dateFormat: "yy-mm-dd"
    showTimezone: true
    timezoneList: [
      value: "-0500"
      label: "Bogotá, Lima, Quito, EST"
    ,
      value: "-0300"
      label: "GMT-3 Buenos Aires"
    ,
      value: "-0600"
      label: "GMT-6 Central"
    ,
      value: "-0700"
      label: "GMT-7 Mountain"
    ,
      value: "-0800"
      label: "GMT-8 Pacific"
    ]
