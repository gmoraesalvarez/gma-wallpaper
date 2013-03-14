unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, Spin, process;

type

  { TForm1 }

  TForm1 = class(TForm)
    ColorDialog1: TColorDialog;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Image1: TImage;
    ListBox1: TListBox;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpinEdit1: TSpinEdit;
    Splitter1: TSplitter;
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  r,g,b,cor,home:string;
  gset:TProcess;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Edit1Click(Sender: TObject);
begin
  ColorDialog1.Color:=StringToColor('$00'+copy(Edit1.Text,6,2)+
    copy(Edit1.Text,4,2)+
    copy(Edit1.Text,2,2) );
  if ColorDialog1.Execute then
  begin
    cor:=ColorToString(ColorDialog1.Color);
    b:=copy(cor,4,2);
    g:=copy(cor,6,2);
    r:=copy(cor,8,2);
    Edit1.Text:='#'+r+g+b;
    gset.CommandLine:='gsettings set org.gnome.desktop.background primary-color '+Edit1.Text;
    gset.Execute;
  end;

end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  gset.CommandLine:='gsettings set org.gnome.desktop.background picture-options '+ComboBox1.Text;
  gset.Execute;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
  gset.CommandLine:='gsettings set org.gnome.desktop.background color-shading-style '+ComboBox2.Text;
  gset.Execute;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin

end;

procedure TForm1.Edit2Change(Sender: TObject);
begin

end;

procedure TForm1.Edit2Click(Sender: TObject);
begin
  ColorDialog1.Color:=StringToColor('$00'+copy(Edit1.Text,6,2)+
    copy(Edit1.Text,4,2)+
    copy(Edit1.Text,2,2) );
  if ColorDialog1.Execute then
  begin
    cor:=ColorToString(ColorDialog1.Color);
    b:=copy(cor,4,2);
    g:=copy(cor,6,2);
    r:=copy(cor,8,2);
    Edit2.Text:='#'+r+g+b;
    gset.CommandLine:='gsettings set org.gnome.desktop.background secondary-color '+Edit2.Text;
    gset.Execute;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ListBox1.Items.SaveToFile(home+'/.gmawallpapers');
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  gw:TStringList;
begin
  home:=GetEnvironmentVariableUTF8('HOME');
  if FileExistsUTF8(home+'/.gmawallpapers') then
    ListBox1.Items.LoadFromFile(home+'/.gmawallpapers');
  gw:=TStringList.Create;
  gset:=TProcess.Create(self);
  gset.Options:=gset.Options+[poWaitOnExit,poUsePipes];

  gset.CommandLine:='gsettings get org.gnome.desktop.background picture-uri';
  gset.Execute;
  gw.LoadFromStream(gset.Output);
  Caption:=StringReplace(gw.Strings[0],'''','',[rfReplaceAll]);

  gset.CommandLine:='gsettings get org.gnome.desktop.background picture-options';
  gset.Execute;
  gw.LoadFromStream(gset.Output);
  ComboBox1.Text:=StringReplace(gw.Strings[0],'''','',[rfReplaceAll]);

  gset.CommandLine:='gsettings get org.gnome.desktop.background primary-color';
  gset.Execute;
  gw.LoadFromStream(gset.Output);
  Edit1.Text:=StringReplace(gw.Strings[0],'''','',[rfReplaceAll]);

  gset.CommandLine:='gsettings get org.gnome.desktop.background secondary-color';
  gset.Execute;
  gw.LoadFromStream(gset.Output);
  Edit2.Text:=StringReplace(gw.Strings[0],'''','',[rfReplaceAll]);

  gset.CommandLine:='gsettings get org.gnome.desktop.background color-shading-type';
  gset.Execute;
  gw.LoadFromStream(gset.Output);
  ComboBox2.Text:=StringReplace(gw.Strings[0],'''','',[rfReplaceAll]);

  {gset.CommandLine:='gsettings get org.gnome.desktop.background picture-opacity';
  gset.Execute;
  gw.LoadFromStream(gset.Output);
  SpinEdit1.Value:=StrToInt(StringReplace(gw.Text,'"','',[rfReplaceAll]));
  }
  gw.Free;

end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
  Image1.Picture.LoadFromFile(ListBox1.GetSelectedText);
  Image1.Proportional:=true;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  gset.CommandLine:='gsettings set org.gnome.desktop.background picture-uri file:'+
    ListBox1.GetSelectedText;
  gset.Execute;
end;

procedure TForm1.ListBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then ListBox1DblClick(self);
  if key = 46 then SpeedButton3Click(self);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin

end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    ListBox1.Items.AddStrings(OpenDialog1.Files);
  end;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  ListBox1.Items.Delete(ListBox1.ItemIndex);
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  gset.CommandLine:='gsettings set org.gnome.desktop.background picture-opacity '+
    SpinEdit1.Text;
  gset.Execute;
end;

end.

