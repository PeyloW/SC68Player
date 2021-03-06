/**
 * @ingroup   emu68_error_devel
 * @file      emu68/error68.h
 * @author    Benjamin Gerard <ben@sashipa.com>
 * @date      1999/03/13
 * @brief     Error message header
 *
 * $Id: error68.h 503 2005-06-24 08:52:56Z loke $
 *
 */

/* Copyright (C) 1998-2003 Benjamin Gerard */

#ifndef _EMU68_ERROR68_H_
#define _EMU68_ERROR68_H_

#ifdef __cplusplus
extern "C" {
#endif

/** @defgroup  emu68_error_devel  Error message stack
 *  @ingroup   emu68_devel
 *
 *    EMU68 error handling consists on a fixed size stack of messages. When
 *    an EMU68 function fails, it stores a description message for the error
 *    and returns a negative number. If error stack is full, the older
 *    stacked message is removed.
 *
 * @{
 */

/** Push formatted error message.
 *
 *     The EMU68error_add() format error message and push it in error stack.
 *     On overflow the older message is lost.
 *
 *  @param format printf() like format string.
 *
 *  @return error-code
 *  @retval 0xDEAD0xxx, where xxx is a random value
 */
int EMU68error_add(char *format, ... );

/** Pop last error message.
 *
 *    Retrieve and remove last error message from error stack.
 *
 *   @return  Last pushed error message.
 *   @retval  0  Empty message stack, no more message.
 */
const char * EMU68error_get(void);

/**
 *@}
 */

#ifdef __cplusplus
}
#endif

#endif /* #ifndef _EMU68_ERROR68_H_ */
