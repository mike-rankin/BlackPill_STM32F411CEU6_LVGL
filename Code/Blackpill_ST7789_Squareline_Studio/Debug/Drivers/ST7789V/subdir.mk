################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Drivers/ST7789V/fonts.c \
../Drivers/ST7789V/st7789v.c 

OBJS += \
./Drivers/ST7789V/fonts.o \
./Drivers/ST7789V/st7789v.o 

C_DEPS += \
./Drivers/ST7789V/fonts.d \
./Drivers/ST7789V/st7789v.d 


# Each subdirectory must supply rules for building sources it contributes
Drivers/ST7789V/%.o Drivers/ST7789V/%.su Drivers/ST7789V/%.cyclo: ../Drivers/ST7789V/%.c Drivers/ST7789V/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F411xE -c -I../Core/Inc -I"C:/Users/mrankin/OneDrive/STM32_Workspace/Blackpill_ST7789_Squareline_Studio/Drivers/lvgl" -I"C:/Users/mrankin/OneDrive/STM32_Workspace/Blackpill_ST7789_Squareline_Studio/Drivers/ST7789V" -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Drivers-2f-ST7789V

clean-Drivers-2f-ST7789V:
	-$(RM) ./Drivers/ST7789V/fonts.cyclo ./Drivers/ST7789V/fonts.d ./Drivers/ST7789V/fonts.o ./Drivers/ST7789V/fonts.su ./Drivers/ST7789V/st7789v.cyclo ./Drivers/ST7789V/st7789v.d ./Drivers/ST7789V/st7789v.o ./Drivers/ST7789V/st7789v.su

.PHONY: clean-Drivers-2f-ST7789V

