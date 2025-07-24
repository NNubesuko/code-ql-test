using System.Web;

namespace WebFormApplication2
{
    public class HelloContext
    {
        static readonly string Key = "Hello";

        public static string Get()
        {
            return HttpContext.Current.Session[Key] as string ?? string.Empty;
        }

        public static void Set(string value)
        {
            HttpContext.Current.Session[Key] = value;
        }
    }
}