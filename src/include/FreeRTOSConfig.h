#ifndef FREERTOS_CONFIG_H
#define FREERTOS_CONFIG_H

#include <avr/io.h>

#define configCPU_CLOCK_HZ				( ( unsigned long ) F_CPU )
#define configIDLE_SHOULD_YIELD			1
#define configMAX_CO_ROUTINE_PRIORITIES ( 2 )
#define configMAX_PRIORITIES			( 4 )
#define configMAX_TASK_NAME_LEN			( 8 )
#define configMINIMAL_STACK_SIZE		( ( unsigned short ) 100 )
#define configQUEUE_REGISTRY_SIZE		0
#define configTICK_RATE_HZ				( ( TickType_t ) 1000 )
#define configTOTAL_HEAP_SIZE			( (size_t ) ( 1500 ) )
#define configUSE_16_BIT_TICKS			1
#define configUSE_CO_ROUTINES 			1
#define configUSE_IDLE_HOOK				0
#define configUSE_PREEMPTION			1
#define configUSE_TICK_HOOK				0
#define configUSE_TRACE_FACILITY		0

#define INCLUDE_uxTaskPriorityGet		0
#define INCLUDE_vTaskCleanUpResources	0
#define INCLUDE_vTaskDelay				1
#define INCLUDE_vTaskDelayUntil			0
#define INCLUDE_vTaskDelete				1
#define INCLUDE_vTaskPrioritySet		0
#define INCLUDE_vTaskSuspend			0

#endif /* FREERTOS_CONFIG_H */
