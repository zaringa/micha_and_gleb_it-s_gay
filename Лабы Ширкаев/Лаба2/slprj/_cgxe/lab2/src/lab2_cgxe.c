/* Include files */

#include "lab2_cgxe.h"
#include "m_kTXGcb5dYsHaz2DbMUZySC.h"

unsigned int cgxe_lab2_method_dispatcher(SimStruct* S, int_T method, void* data)
{
  if (ssGetChecksum0(S) == 2351408006 &&
      ssGetChecksum1(S) == 3431034949 &&
      ssGetChecksum2(S) == 1450034783 &&
      ssGetChecksum3(S) == 319269177) {
    method_dispatcher_kTXGcb5dYsHaz2DbMUZySC(S, method, data);
    return 1;
  }

  return 0;
}
