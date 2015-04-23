#ifndef _SCGENMOD_data_mem_
#define _SCGENMOD_data_mem_

#include "systemc.h"

class data_mem : public sc_foreign_module
{
public:
    sc_in<sc_logic> clock;
    sc_in<sc_lv<16> > data;
    sc_in<sc_lv<16> > rdaddress;
    sc_in<sc_lv<16> > wraddress;
    sc_in<sc_logic> wren;
    sc_out<sc_lv<16> > q;


    data_mem(sc_module_name nm, const char* hdl_name)
     : sc_foreign_module(nm),
       clock("clock"),
       data("data"),
       rdaddress("rdaddress"),
       wraddress("wraddress"),
       wren("wren"),
       q("q")
    {
        elaborate_foreign_module(hdl_name);
    }
    ~data_mem()
    {}

};

#endif

