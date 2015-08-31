#
# Copyright (c) 2015, Radu Oana <oanaradu32 at gmail dot com>
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

#http://elinux.org/EBC_Exercise_13_Pulse_Width_Modulation
import bone, bone/cape, strutils, os

const
  capeName = "am33xx_pwm"
  pwmNameTamplate = "bone_pwm_$1"
  pwmPeriodFile = "/sys/devices/ocp.?/pwm_test_$1.??/period"
  pwmDutyFile = "/sys/devices/ocp.?/pwm_test_$1.??/duty"

proc pinModePWM* (pin: string, freqHz: int32) =
  if bone.hasPWM(pin):
    cape.enable(capeName)
    cape.enable(pwmNameTamplate % [pin])

    if freqHz > 0:
      let period = int64((1/float(freqHz)) * 1_000_000_000) #to nanoseconds
      let periodFile = pwmPeriodFile % [pin]
      cape.waitForFile(periodFile)
      cape.writeFile(periodFile, $period)
    #end
  else:
    raise newException(ValueError, "Pin '" & pin & "' does not support PWM")
  #end
#end

proc pinModePWM* (pin: string) =
  pinModePWM(pin, int32(0))
#end

proc checkDuty (duty: float) =
  if duty < 0 or duty > 1:
    raise newException(ValueError, "Duty is a percentage value between [0..1]. Got " & $duty)
  #end
#end

proc getDutyInNs(duty: float, period: int64): int64 =
  result = int64(float(period) * duty)
#end

proc analogWrite* (pin: string, duty: float) =
  ## Use pwm to write an analogic output.

  checkDuty(duty)

  let period = int64(parseInt(strip(cape.readFile(pwmPeriodFile % [pin]), true, true)))

  cape.writeFile(pwmDutyFile % [pin], $getDutyInNs(duty, period))
#end

# Testing
when isMainModule:
  discard
