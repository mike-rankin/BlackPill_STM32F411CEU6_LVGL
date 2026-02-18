# CST816S — STM32 HAL Driver

A C driver for the **Hynitron CST816S** capacitive touch controller, written for the STM32 HAL ecosystem.

Ported from the Arduino library by [fbiego](https://github.com/fbiego/CST816S).

---

## Files

| File | Description |
|------|-------------|
| `CST816S.h` | Public API, register map, data types |
| `CST816S.c` | Driver implementation |

---

## Integration

### 1 — Copy files into your project

Drop `CST816S.h` and `CST816S.c` into your project's `Drivers/` or `Inc/` / `Src/` folders as appropriate.

### 2 — Fix the HAL include

Open `CST816S.h` and replace the placeholder include near the top:

```c
// Change this:
#include "stm32_hal_include.h"

// To match your MCU family, e.g.:
#include "stm32f4xx_hal.h"
// or simply:
#include "main.h"   // if main.h already pulls in the right HAL header
```

### 3 — Enable the I²C peripheral

Use STM32CubeMX (or write it by hand) to configure an I²C peripheral at **400 kHz** (Fast Mode). The CST816S I²C address is **0x15** (7-bit).

### 4 — Configure GPIO

| Signal | Direction | Note |
|--------|-----------|-------|
| RST    | Output push-pull | Drive LOW to reset, HIGH to run |
| INT    | Input with EXTI  | Active-LOW interrupt from the IC |

In CubeMX set INT as `GPIO_EXTI` on the falling edge and enable the corresponding `EXTIx_IRQn` in NVIC.

---

## API Quick-Start

```c
#include "CST816S.h"

/* Declare a driver handle (can be global or stack-allocated) */
CST816S_Handle_t touch;

/* ── Initialise once (e.g. in main, after HAL_Init and MX_I2C_Init) ─────── */
bool ok = CST816S_Init(&touch,
                       &hi2c1,           // your HAL I2C handle
                       TOUCH_RST_GPIO_Port, TOUCH_RST_Pin,  // RST GPIO
                       TOUCH_INT_GPIO_Port, TOUCH_INT_Pin); // INT GPIO

if (!ok) {
    Error_Handler();  // device not found on bus
}

/* Optional: disable auto-sleep for maximum responsiveness (+~1.6 mA) */
CST816S_DisableAutoSleep(&touch);

/* Optional: set a 10-second auto-sleep timeout */
CST816S_SetAutoSleepTime(&touch, 10);

/* Optional: enable double-click and continuous swipe detection */
CST816S_SetMotionMask(&touch,
                      CST816S_MOTION_EN_DCLICK |
                      CST816S_MOTION_EN_CON_UD |
                      CST816S_MOTION_EN_CON_LR);

/* ── Forward EXTI events from the HAL callback ───────────────────────────── */
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
    CST816S_EXTI_Callback(&touch, GPIO_Pin);
}

/* ── Poll in your main loop (or task) ────────────────────────────────────── */
while (1)
{
    if (CST816S_Available(&touch))
    {
        uint16_t x       = touch.touch.x;
        uint16_t y       = touch.touch.y;
        uint8_t  fingers = touch.touch.finger_num;

        switch (touch.touch.gesture)
        {
            case GESTURE_SINGLE_CLICK: /* handle tap   */ break;
            case GESTURE_DOUBLE_CLICK: /* handle d-tap */ break;
            case GESTURE_SWIPE_UP:     /* handle swipe */ break;
            case GESTURE_SWIPE_DOWN:                      break;
            case GESTURE_SWIPE_LEFT:                      break;
            case GESTURE_SWIPE_RIGHT:                     break;
            case GESTURE_LONG_PRESS:                      break;
            default: break;
        }
    }
}
```

---

## Polling Mode (no INT pin)

If you don't connect the INT line, pass `NULL` for `int_port`:

```c
CST816S_Init(&touch, &hi2c1,
             RST_GPIO_Port, RST_Pin,
             NULL, 0);   // no interrupt pin
```

`CST816S_Available()` will then always read over I²C and return `true` whenever a finger is detected. Call it at a suitable rate (e.g. every 20 ms).

---

## Attach a Wake Callback

You can register a function that fires inside the EXTI handler, useful for waking an RTOS task or toggling a flag:

```c
void touch_wake(void)
{
    // e.g. set an RTOS event bit
    osEventFlagsSet(touch_flags, TOUCH_FLAG);
}

CST816S_AttachInterrupt(&touch, touch_wake);
```

---

## Reading Device Info

```c
uint8_t chip_id, proj_id, fw_ver;
if (CST816S_GetInfo(&touch, &chip_id, &proj_id, &fw_ver))
{
    printf("Chip: 0x%02X  Proj: 0x%02X  FW: 0x%02X\n", chip_id, proj_id, fw_ver);
}
```

---

## Gesture Reference

| Gesture constant | Value | Description |
|------------------|-------|-------------|
| `GESTURE_NONE`         | 0x00 | No gesture |
| `GESTURE_SWIPE_UP`     | 0x01 | Swipe up |
| `GESTURE_SWIPE_DOWN`   | 0x02 | Swipe down |
| `GESTURE_SWIPE_LEFT`   | 0x03 | Swipe left |
| `GESTURE_SWIPE_RIGHT`  | 0x04 | Swipe right |
| `GESTURE_SINGLE_CLICK` | 0x05 | Single tap |
| `GESTURE_DOUBLE_CLICK` | 0x0B | Double tap |
| `GESTURE_LONG_PRESS`   | 0x0C | Long press |

---

## Key Registers

| Register | Address | Default | Purpose |
|----------|---------|---------|---------|
| `DisAutoSleep` | 0xFE | 0 (on) | Non-zero = disable auto-sleep |
| `AutoSleepTime` | 0xF9 | 2 s | Inactivity timeout |
| `MotionMask` | 0xEC | 0x00 | Enable double-click / continuous swipe |
| `IrqCtl` | 0xFA | — | Interrupt pulse behaviour |
| `ChipID` | 0xA7 | — | Read-only chip identifier |

---

## Licence

MIT — same as the original Arduino library.
