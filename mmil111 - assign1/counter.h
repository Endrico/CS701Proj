#ifndef _SCGENMOD_counter_
#define _SCGENMOD_counter_

#include "systemc.h"

class counter : public sc_foreign_module
{
public:
    sc_in<sc_logic> CLK;
    sc_out<sc_lv<14> > C_Out;


    counter(sc_module_name nm, const char* hdl_name)
     : sc_foreign_module(nm),
       CLK("CLK"),
       C_Out("C_Out")
    {
        elaborate_foreign_module(hdl_name);
    }
    ~counter()
    {}

};

#endif

