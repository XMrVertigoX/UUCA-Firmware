#ifndef LIB_MCP4151_H_
#define LIB_MCP4151_H_

#define MCP4151_8_CMD0 2
#define MCP4151_8_CMD1 3
#define MCP4151_8_MEM0 4
#define MCP4151_8_MEM1 5
#define MCP4151_8_MEM2 6
#define MCP4151_8_MEM3 7

#define MCP4151_8_WIPER0    0
#define MCP4151_8_WIPER1    (1 << MCP4151_8_MEM0)
#define MCP4151_8_INCREASE  (1 << MCP4151_8_CMD0)
#define MCP4151_8_DECREASE  (1 << MCP4151_8_CMD1)

#define MCP4151_16_CMD0 10
#define MCP4151_16_CMD1 11
#define MCP4151_16_MEM0 12
#define MCP4151_16_MEM1 13
#define MCP4151_16_MEM2 14
#define MCP4151_16_MEM3 15

#define MCP4151_16_WIPER0   0
#define MCP4151_16_WIPER1   (1 << MCP4151_16_MEM0)
#define MCP4151_16_INCREASE (1 << MCP4151_16_CMD0)
#define MCP4151_16_DECREASE (1 << MCP4151_16_CMD1)
#define MCP4151_16_TCON     (1 << MCP4151_16_MEM2)
#define MCP4151_16_STATUS   ((1 << MCP4151_16_MEM0) | (1 << MCP4151_16_MEM2))
#define MCP4151_16_READ     ((1 << MCP4151_16_CMD0) | (1 << MCP4151_16_CMD1))
#define MCP4151_16_WRITE    0

#endif
