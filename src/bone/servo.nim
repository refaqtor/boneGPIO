#
# Copyright (c) 2015 Radu Oana <oanaradu32@gmail.com>
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
#

import bone/pwm

type
  Servo*: object
    minDuty: float = 0.0375 #most common value
    maxDuty: float = 0.1125 #most common value
    freqHz: int32 = 50 #most common value
    pinName: string = ""

proc positionToDuty(servo: Servo, position: float): float =
  result = (servo.maxDuty - servo.minDuty) * position

proc getServo* (pin: string): Servo =
  ## Creates a new servo object with most common values.
  new(result)
  result.pinName = pin
  pwm.analogWrite(result.pin, (result.minDuty + result.maxDuty)/2, result.freqHz)

proc moveServo* (servo: Servo, position: float) =
  ## Command the servo to move.
  if position < 0 or position > 1:
    raise newException(ValueError, "Duty is a percentage value between [0..1]. Got " & $possition)

  pwm.analogWrite(servo.pinName, positionToDuty(position))