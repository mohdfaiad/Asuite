{
Copyright (C) 2006-2009 Matteo Salvi and Shannara

Website: http://www.salvadorsoftware.com/

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
}

unit udImages;

{$I ASuite.inc}

interface

uses
  SysUtils, Classes, Controls, Windows, Graphics, Dialogs, ulEnumerations,
  ulNodeDataTypes, ShellApi, CommCtrl, Vcl.ImgList;


type
  TRGBArray = array[Word] of TRGBTriple;
  pRGBArray = ^TRGBArray;

  TResType = (rtBMP, rtPNG, rtICO);

  TImagesDM = class(TDataModule)
    IcoImages: TImageList;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    function LoadIconFromFile(ID: Integer): Integer;
    procedure SaveCacheIcon(Path: string; NodeData: TvBaseNodeData; ImageIndex: Integer);
  public
    { Public declarations }
    function GetIconIndex(NodeData:TvBaseNodeData): Integer;
    procedure DeleteCacheIcon(NodeData: TvBaseNodeData);
    function GetSimpleIconIndex(xpath : string): integer;
  end;

var
  ImagesDM: TImagesDM;

implementation

uses
  AppConfig, ulAppConfig;

{$R *.dfm}

function TImagesDM.GetIconIndex(NodeData:TvBaseNodeData): Integer;
var
  TempPath : String;
begin
  Result := -1;
  //Priority cache->icon->exe
  //Check cache icon
  if Not(FileExists(NodeData.PathCacheIcon)) and (NodeData.CacheID <> -1) then
    NodeData.CacheID := -1;
  if (Config.Cache) and FileExists(NodeData.PathCacheIcon) then
      TempPath := NodeData.PathCacheIcon;
  //Icon
  if NodeData.CacheID = -1 then
  begin
    if FileExists(NodeData.PathAbsoluteIcon) then
      TempPath := NodeData.PathAbsoluteIcon
    else
      //Exe, if nodedata is a file item
      if NodeData.DataType = vtdtFile then
      begin
        if (FileExists((NodeData as TvFileNodeData).PathAbsoluteExe)) or
           (DirectoryExists((NodeData as TvFileNodeData).PathAbsoluteExe)) then
          TempPath := (NodeData as TvFileNodeData).PathAbsoluteExe;
      end
      else begin
        if NodeData.DataType = vtdtCategory then
          Result := IMG_Cat;
      end;
  end;
  //Get image index
  if (TempPath <> '') and (Result <> IMG_Cat) then
    Result := GetSimpleIconIndex(TempPath);
  SaveCacheIcon(TempPath, NodeData, Result);
end;

procedure TImagesDM.DeleteCacheIcon(NodeData: TvBaseNodeData);
begin
  //Check Cache icon
  if (Config.Cache) then
  begin
    if FileExists(NodeData.PathCacheIcon) then
      DeleteFile(PWideChar(NodeData.PathCacheIcon));
    NodeData.CacheID := -1;
    NodeData.Changed := True;
  end
end;

procedure TImagesDM.SaveCacheIcon(Path: string; NodeData: TvBaseNodeData; ImageIndex: Integer);
var
  I    : Integer;
  Icon : TIcon;
begin
  if (NodeData.CacheID = -1) and (Config.Cache) then
  begin
    //Save file cache-icon
    if (FileExists(Path)) then
      if (LowerCase(ExtractFileExt(Path)) <>  EXT_ICO) then
      begin
        I := 0;
        //Get first ID slot free
        while (FileExists(SUITE_CACHE_PATH + IntToStr(I) + EXT_ICO)) do
          Inc(I);
        //Save cache icon in disk
        Icon := TIcon.Create;
        try
          IcoImages.GetIcon(ImageIndex, Icon);
          if Icon.HandleAllocated then
          begin
            Icon.SaveToFile(SUITE_CACHE_PATH + IntToStr(I) + EXT_ICO);
            NodeData.CacheID := I;
            NodeData.Changed := True;
          end;
        finally
          Icon.Free;
        end;
      end
      else
        NodeData.CacheID := -1;
  end;
end;

function TImagesDM.LoadIconFromFile(ID: Integer): Integer;
var
  FileName : String;
begin
  Result   := -1;
  FileName := SUITE_ICONS_PATH + IntToStr(ID) + EXT_ICO;
  if FileExists(FileName) then
    Result := GetSimpleIconIndex(FileName)
  else
    ShowMessageFmt(msgErrNoIcon, [IntToStr(ID) + EXT_ICO]);
end;

function TImagesDM.GetSimpleIconIndex(xpath: string): integer;
var
  FileInfo : TSHFileInfoW;
begin
  //Get icon
  SHGetFileInfo(PChar(xpath), 0, FileInfo, SizeOf(TSHFileInfo), SHGFI_SYSICONINDEX or
                                                                SHGFI_SMALLICON or
                                                                SHGFI_USEFILEATTRIBUTES);
  Result := FileInfo.iIcon;
end;

procedure TImagesDM.DataModuleCreate(Sender: TObject);
var
  Flags: integer;
  SFI: TSHFileInfoW;
begin
  //Use System ImageList
  Flags := SHGFI_SYSICONINDEX or SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES;
  IcoImages.Handle      := SHGetFileInfo('', 0, SFI, SizeOf(SFI), Flags);
  IcoImages.ShareImages := True;
  //Menu icons
  IMG_ASuite     := LoadIconFromFile(0);
  IMG_Cat        := LoadIconFromFile(1);
  IMG_Help       := LoadIconFromFile(2);
  IMG_Options    := LoadIconFromFile(3);
  IMG_AddCat     := LoadIconFromFile(4);
  IMG_AddFile    := LoadIconFromFile(5);
  IMG_AddFolder  := LoadIconFromFile(6);
  IMG_Delete     := LoadIconFromFile(7);
  IMG_Property   := LoadIconFromFile(8);
  IMG_Save       := LoadIconFromFile(9);
  IMG_Folder     := LoadIconFromFile(10);
  IMG_AddGroupFile := LoadIconFromFile(11);
  IMG_GroupFile  := LoadIconFromFile(12);
  IMG_NOTFOUND   := LoadIconFromFile(13);
  IMG_Run        := LoadIconFromFile(14);
  IMG_Cut        := LoadIconFromFile(15);
  IMG_Copy       := LoadIconFromFile(16);
  IMG_Paste      := LoadIconFromFile(17);
  IMG_Search     := LoadIconFromFile(18);
  IMG_SearchType := LoadIconFromFile(19);
  IMG_Url        := LoadIconFromFile(20);
  IMG_Accept     := LoadIconFromFile(21);
  IMG_Cancel     := LoadIconFromFile(22);
end;

end.
