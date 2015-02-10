$window = $(window)
$body   = $('body')
windowHeight = 0
windowWidth = 0
bodyHeight = 0
currentKeyframe = 0
prevKeyframesDurations = 0
relativeScrollTop = 0
scrollTop = 0


letters = 'supdawg'
letterTemplate =
  '''
    <div class="letter-<%= letter %>">
      <div class="letter"><%= letter %></div>
    </div>
  '''


keyframes = (
  {
    selector: ".letter-#{letter}"
    duration: 1.5  # 1 = 100% of the body's height
    'animations': [
      selector: '.letter'
      translateY: 10000  # these shoudl be calculated from the window size
      translateX: 10000
      opacity: [1, 0.5]
    ]
  } for letter in letters
)

templates = (_.template(letterTemplate)({letter}) for letter in letters)

buildPage = ->
  windowHeight = window.innerHeight
  windowWidth = window.innerWidth
  console.log 'in', windowHeight
  console.log keyframes
  for keyframe, index in keyframes
    console.log keyframe
    keyframe.duration = keyframe.duration * windowHeight
    elHeight = keyframe.duration
    bodyHeight += elHeight
    $el = $(templates[index])
    $el.height(elHeight)
    randomColorStyle = "rgb(#{colors[Math.floor(Math.random() * colors.length)]})"
    $el.css 'background-color', randomColorStyle

    $('.parallax').append $el

    # adjust the translates and stuff to have 2 values
    for animation, index in keyframe.animations
      Object.keys(animation).forEach (key) ->
        value = animation[key]
        if(key isnt 'selector' and value instanceof Array is false)
          if key is 'translateY'
            value = keyframe.duration + windowHeight / 2
            console.log 'HELLLLLL', value
          if key is 'translateX'
            value = windowWidth / 2
          valueSet = []
          valueSet.push getDefaultPropertyValue(key), value
          console.log 'SHOULD BE TGWO VALUE', valueSet
          value = valueSet
        animation[key] = value

  console.log 'hi', bodyHeight
  $body.height(bodyHeight)
  $window.scroll 0


easeInOutQuad = (t, b, c, d) ->
  console.log 'hello', t, b, c, d
  return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b

getDefaultPropertyValue = (property) ->
  switch (property)
    when 'translateX' then return 0
    when 'translateY' then return 0
    when 'scale' then return 1
    when 'rotate' then return 0
    when 'opacity' then return 1


calcPropValue = (animation, property) ->
  value = animation[property]
  console.log 'this is value', value
  if value?
    value = easeInOutQuad(relativeScrollTop, value[0], (value[1]-value[0]), keyframes[currentKeyframe].duration)
  else
    value = getDefaultPropertyValue(property)
  return value



animate = ->
  currentKey = keyframes[currentKeyframe]
  for animation in currentKey.animations
    {selector, translateX, translateY, opacity} = animation
    translateX = calcPropValue(animation, 'translateX')
    translateY = calcPropValue(animation, 'translateY')
    opacity = calcPropValue(animation, 'opacity')
    console.log 'one', selector, translateX, translateY, opacity
    console.log 'two', $("#{currentKey.selector} #{selector}"), "translate3d(#{translateX}, #{translateY}, 0)"
    $("#{currentKey.selector} #{selector}").css
      transform: "translate3d(#{translateX}px, #{translateY}px, 0)"
      opacity: opacity


setKeyFrame = ->
  if(scrollTop > (keyframes[currentKeyframe].duration + prevKeyframesDurations) )
    $("#{keyframes[currentKeyframe].selector} .letter").addClass 'sticky'



    prevKeyframesDurations += keyframes[currentKeyframe].duration
    currentKeyframe++
    showCurrentWrappers()
  else if(scrollTop < prevKeyframesDurations)
    currentKeyframe--
    $("#{keyframes[currentKeyframe].selector} .letter").removeClass 'sticky'
    prevKeyframesDurations -= keyframes[currentKeyframe].duration
    showCurrentWrappers()


update = ->
  window.requestAnimationFrame ->
    scrollTop = $window.scrollTop()
    relativeScrollTop = scrollTop - prevKeyframesDurations
    console.log 'hhhhhhhffff',relativeScrollTop
    console.log bodyHeight - windowHeight
    if scrollTop > 0 and scrollTop <= (bodyHeight - windowHeight)
      console.log 'requested animation frame'
      animate()
      setKeyFrame()

init = ->
  $(document).scroll(_.throttle update
   , 10, leading: false)
  buildPage()

$ ->
  init()




colors = [
  "174, 232, 125"
  "210, 232, 125"
  "220, 232, 125"
  "232, 213, 125"
  "232, 165, 125"
  "232, 202, 125"
  "232, 173, 124"
  "213, 232, 125"
  "183, 233, 124"
  "232, 126, 125"
  "232, 228, 125"
  "232, 146, 124"
  "232, 165, 125"
  "232, 150, 125"
  "232, 130, 125"
  "232, 196, 126"
]


