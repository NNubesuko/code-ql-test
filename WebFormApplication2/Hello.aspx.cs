using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Text;
using System.Web.UI;

namespace WebFormApplication2
{
    public partial class Hello : Page
    {
        readonly int _x = 0;
        readonly int _y = 1;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void ClickTestButton(object sender, EventArgs e)
        {
            var builder =
                new SqlConnectionStringBuilder(Environment.GetEnvironmentVariable("TEST_CONNECTION"))
                {
                    UserID = Environment.GetEnvironmentVariable("TEST_USER_NAME"),
                    Password = Environment.GetEnvironmentVariable("TEST_PASSWORD"),
                };
            var connectionString = builder.ToString();

            var testDbName = ConfigurationManager.AppSettings["TEST_DB_NAME"];
            var testSchemaName = ConfigurationManager.AppSettings["TEST_SCHEMA_NAME"];
            var testTableName = ConfigurationManager.AppSettings["TEST_TABLE_NAME"];

            var column1 = ConfigurationManager.AppSettings["TEST_COLUMN1"];
            var column2 = ConfigurationManager.AppSettings["TEST_COLUMN2"];

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                var command =
                    new SqlCommand(
                        $"SELECT TOP 100 * FROM [{testDbName}].[{testSchemaName}].[{testTableName}] WHERE [{column2}] = @Test ORDER BY [{column2}] DESC",
                        connection);

                command.Parameters.Add(new SqlParameter("@Test", SqlDbType.Int, 10) { Value = TestInput.Text });

                var sb = new StringBuilder();
                using (var reader = command.ExecuteReader())
                {
                    var index = 1;
                    while (reader.Read())
                    {
                        sb.Append($"{index++}, Column1: {reader[column1]}, Column2: {reader[column2]}")
                            .Append("<br>");
                    }
                }

                var result = sb.ToString();
                Output.Text = string.IsNullOrEmpty(result) ? "データ無し" : result;
            }
        }

        protected void ClickAddButton(object sender, EventArgs e)
        {
            unsafe
            {
                fixed (int* px = &_x, py = &_y)
                {
                    TestUtil.Add(px, py);
                }
            }

            AddResult.Text = _x.ToString();
        }

        protected void ClickExecutionButton(object sender, EventArgs e)
        {
            var startInfo = new ProcessStartInfo("OutSide.exe");
            startInfo.UseShellExecute = true;

            Process.Start(startInfo);
        }
    }
}