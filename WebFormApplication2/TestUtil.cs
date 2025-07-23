using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebFormApplication2
{
    public class TestUtil
    {
        public static unsafe void Add(int* x, int* y)
        {
            *x += *y;
        }
    }
}