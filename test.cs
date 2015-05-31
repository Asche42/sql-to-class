using System;
using System.Data;
using MySql.Data.MySqlClient;

class Test {
  public Int64 A { get; set; }
  public Int32 B { get; set; }
  public Int64 C { get; set; }

  void InsertToDb() {
    MySqlConnection dbcon = new MySqlConnection("Server=localhost;Database=mydb;User ID=user;Password=password;Pooling=false;Convert Zero Datetime=True");
    String sql = "INSERT INTO Tests(A, B, C) VALUES(@A, @B, @C)";
    MySqlCommand cmd = new MySqlCommand(sql, dbcon);

    cmd.Parameters.AddWithValue("@A", A);
    cmd.Parameters.AddWithValue("@B", B);
    cmd.Parameters.AddWithValue("@C", C);


    cmd.CommandType = CommandType.Text;
    cmd.ExecuteNonQuery();
  }
}

