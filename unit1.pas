//Copyright 2019 Andrey S. Ionisyan (anserion@gmail.com)
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

// Very simple FTP-client with GUI

unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  CodeBot.Networking.Ftp,lazutf8;

type

  { TForm1 }

  TForm1 = class(TForm)
    Bevel1: TBevel;
    cmd_filename_edit: TEdit;
    ftp_get_btn: TButton;
    ftp_pwd_btn: TButton;
    ftp_list_btn: TButton;
    ftp_cdup_btn: TButton;
    ftp_cwd_btn: TButton;
    ftp_screen_memo: TMemo;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    sign_in_btn: TButton;
    FTP_name_edit: TEdit;
    ftp_user_edit: TEdit;
    ftp_password_edit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ftp_quit_btn: TButton;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ftp_cdup_btnClick(Sender: TObject);
    procedure ftp_get_btnClick(Sender: TObject);
    procedure ftp_list_btnClick(Sender: TObject);
    procedure ftp_cwd_btnClick(Sender: TObject);
    procedure ftp_pwd_btnClick(Sender: TObject);
    procedure sign_in_btnClick(Sender: TObject);
    procedure ftp_quit_btnClick(Sender: TObject);
  private
    procedure MemoScrollDown;
  public

  end;

var
  Form1: TForm1;
  FTP_Client: TFTPClient;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MemoScrollDown;
begin
  ftp_screen_memo.SelStart:=UTF8Length(ftp_screen_memo.Text);
  ftp_screen_memo.SelLength:=0;
  ftp_screen_memo.SetFocus;
end;

procedure TForm1.sign_in_btnClick(Sender: TObject);
begin
  Ftp_Client.Host := ftp_name_edit.text;
  Ftp_Client.UserName:=ftp_user_edit.text;
  Ftp_Client.Password:=ftp_password_edit.text;
  if Ftp_Client.Connect
  then ftp_screen_memo.Append('соединение с '+ftp_name_edit.text+' установлено')
  else ftp_screen_memo.Append('соединение с '+ftp_name_edit.text+' отклонено');
  MemoScrollDown;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Ftp_Client := TFtpClient.Create;
end;

procedure TForm1.ftp_cdup_btnClick(Sender: TObject);
begin
  if FTP_Client.Connected
  then
  begin
    FTP_client.ChangeDir('../');
    ftp_screen_memo.Lines.Append('текущий каталог: '+FTP_Client.GetCurrentDir);
  end
  else ftp_screen_memo.Append('соединение c FTP сервером не установлено');
  MemoScrollDown;
end;

procedure TForm1.ftp_get_btnClick(Sender: TObject);
begin
  if FTP_Client.Connected
  then
  begin
    if FTP_client.FileExists(cmd_filename_edit.text) then
    begin
      ftp_screen_memo.Lines.Append('начинаю загрузку файла '+cmd_filename_edit.text);
      ftp_screen_memo.Refresh;
      FTP_client.FileGet(cmd_filename_edit.text,cmd_filename_edit.text);
      ftp_screen_memo.Lines.Append('файл '+cmd_filename_edit.text+' загружен');
    end
    else ftp_screen_memo.Append('файла '+cmd_filename_edit.text+' в текущем катологе нет');
  end
  else ftp_screen_memo.Append('соединение c FTP сервером не установлено');
  MemoScrollDown;
end;

procedure TForm1.ftp_list_btnClick(Sender: TObject);
begin
  if FTP_Client.Connected
  then
  begin
    ftp_screen_memo.Lines.Append('содержимое каталога '+FTP_Client.GetCurrentDir);
    ftp_screen_memo.Lines.Append(FTP_Client.FileList)
  end
  else ftp_screen_memo.Append('соединение c FTP сервером не установлено');
  MemoScrollDown;
end;

procedure TForm1.ftp_cwd_btnClick(Sender: TObject);
begin
  if FTP_Client.Connected
  then
  begin
    FTP_client.ChangeDir(cmd_filename_edit.text);
    ftp_screen_memo.Lines.Append('текущий каталог: '+FTP_Client.GetCurrentDir);
  end
  else ftp_screen_memo.Append('соединение c FTP сервером не установлено');
 MemoScrollDown;
end;

procedure TForm1.ftp_pwd_btnClick(Sender: TObject);
begin
  if FTP_Client.Connected
  then ftp_screen_memo.Lines.Append('текущий каталог: '+FTP_Client.GetCurrentDir)
  else ftp_screen_memo.Append('соединение c FTP сервером не установлено');
  MemoScrollDown;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    FTP_Client.free;
end;

procedure TForm1.ftp_quit_btnClick(Sender: TObject);
begin
  Ftp_Client.disconnect;
  ftp_screen_memo.Append('текущее соединение выключено');
  MemoScrollDown;
end;

end.

