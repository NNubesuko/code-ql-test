<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Hello.aspx.cs" Inherits="WebFormApplication2.Hello" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <h2>Hello</h2>
    <form id="form1" runat="server">
        <asp:Label Text="Test Input" runat="server" />
        <asp:TextBox ID="TestInput" runat="server" />
        <asp:Button ID="TestButton" Text="Submit" runat="server" OnClick="ClickTestButton" />
        <asp:Label ID="Output" Text="" runat="server" />
    </form>
</body>
</html>
