jQuery ->
  $('#booking-filter input').bookingFilterTime()

$.fn.bookingFilterTime = ->
  @each ->
    $(@).on 'change', ->
      return unless window.booking_filter
      timesState = window.booking_filter.timesState()
      dateFrom = window.booking_filter.datetimeFrom()
      dateFrom = dateFrom.add(1, 'day') if timesState.plus_day
      user = getCurrentUser()
      if !user.maker && dateFrom.isoWeekday() == 7 && dateFrom.hours() < 20
        # Only makers can book on sunday from 8:00 AM to 8:00 PM
        $(document).trigger('map:loading:change', [on, 'Only makers can book on Sunday 8:00 AM - 8:00 PM'])
      else if user.maker && (dateFrom.isoWeekday() != 7 || dateFrom.hours() > 16)
        $(document).trigger('map:loading:change', [on, 'Makers can only book on Sunday 8:00 AM - 8:00 PM'])
      else if dateFrom.isBefore(currentTime())
        $(document).trigger('map:loading:change', [on, 'Booking cannot be in the past.'])
      else if timesState.total < 4
        $(document).trigger('map:loading:change', [on, 'Booking must be at least 4 hours.'])
      else if timesState.total > 12
        $(document).trigger('map:loading:change', [on, 'Booking cannot be more than 12 hours.'])
      else
        $(document).trigger('map:loading:change', off)