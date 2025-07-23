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
        
        <asp:Label Text="Add Button" runat="server" />
        <asp:Label ID="AddResult" Text="" runat="server" />
        <asp:Button ID="AddButton" Text="Add" runat="server" OnClick="ClickAddButton" />
        
        <asp:Label Text="Execution Button" runat="server" />
        <asp:Button ID="ExecutionButton" Text="Add" runat="server" OnClick="ClickExecutionButton" />
        
        <asp:Label Text="Match Input" runat="server" />
        <asp:TextBox ID="MatchInput" runat="server" />
        <asp:TextBox ID="MatchText" runat="server" />
        <asp:Button ID="MatchButton" Text="Submit" runat="server" OnClick="ClickMatchButton" />
        <asp:Label ID="MatchOutput" Text="" runat="server" />
        
        <asp:Label Text="File Input" runat="server" />
        <asp:TextBox ID="FileName" runat="server" />
        <asp:Button ID="FileButton" Text="Submit" runat="server" OnClick="ClickFileButton" />
        <asp:Label ID="FileOutput" Text="" runat="server" />
    </form>
</body>
</html>
