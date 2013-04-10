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

unit ulDatabase;

interface

uses
  Windows, SysUtils, Forms, Dialogs, VirtualTrees, ulNodeDataTypes, ulEnumerations,
  ulCommonClasses, Classes, mORMot, SynCommons, mORMotSQLite3;

type

  { TSQLVersion }

  TSQLtbl_version = class(TSQLRecord) //Table tbl_version
  private
    FMajor   : Integer;
    FMinor   : Integer;
    FRelease : Integer;
    FBuild   : Integer;
  published
    //property FIELDNAME: TYPE read FFIELDNAME write FFIELDNAME;
    property Major   : Integer read FMajor write FMajor;
    property Minor   : Integer read FMinor write FMinor;
    property Release : Integer read FRelease write FRelease;
    property Build   : Integer read FBuild write FBuild;
  end;

  { TSQLFiles }

  TSQLtbl_files = class(TSQLRecord) //Table tbl_files
  private
    Ftype             : Integer;
    Fparent           : TSQLRecord;
    Fposition         : Integer;
    Ftitle            : RawUTF8;
    Fpath             : RawUTF8;
    Fwork_path        : RawUTF8;
    Fparameters       : RawUTF8;
    FdateAdded        : Integer;
    FlastModified     : Integer;
    FlastAccess       : Integer;
    Fclicks           : Integer;
    Fno_mru           : Boolean;
    Fno_mfu           : Boolean;
    Fhide_from_menu   : Boolean;
    Fdsk_shortcut     : Boolean;
    Ficon             : RawUTF8;
    Fcacheicon_id     : Integer;
    Fonlaunch         : Integer;
    Fwindow_state     : Integer;
    Fautorun          : Integer;
    Fautorun_position : Integer;
  published
    //property FIELDNAME: TYPE read FFIELDNAME write FFIELDNAME;
    property itemtype: Integer read Ftype write Ftype;
    property parent: TSQLRecord read Fparent write Fparent;
    property position: Integer read Fposition write Fposition;
    property title: RawUTF8 read Ftitle write Ftitle;
    property path: RawUTF8 read Fpath write Fpath;
    property work_path: RawUTF8 read Fwork_path write Fwork_path;
    property parameters: RawUTF8 read Fparameters write Fparameters;
    property dateAdded: Integer read FdateAdded write FdateAdded;
    property lastModified: Integer read FlastModified write FlastModified;
    property lastAccess: Integer read FlastAccess write FlastAccess;
    property clicks: Integer read Fclicks write Fclicks;
    property no_mru: Boolean read Fno_mru write Fno_mru;
    property no_mfu: Boolean read Fno_mfu write Fno_mfu;
    property hide_from_menu: Boolean read Fhide_from_menu write Fhide_from_menu;
    property dsk_shortcut: Boolean read Fdsk_shortcut write Fdsk_shortcut;
    property icon_path: RawUTF8 read Ficon write Ficon;
    property cacheicon_id: Integer read Fcacheicon_id write Fcacheicon_id;
    property onlaunch: Integer read Fonlaunch write Fonlaunch;
    property window_state: Integer read Fwindow_state write Fwindow_state;
    property autorun: Integer read Fautorun write Fautorun;
    property autorun_position: Integer read Fautorun_position write Fautorun_position;
  end;

  { TDBManager }

  TDBManager = class
  private
    FDBFileName : string;
    FDatabase   : TSQLRest;
    FSQLModel   : TSQLModel;
    FDBVersion  : TVersionInfo;
    procedure InternalLoadVersion;
    procedure InternalLoadData(Tree: TBaseVirtualTree; IsImport: Boolean = false);
    procedure InternalLoadListItems(Tree: TBaseVirtualTree; ID: Integer;
                            ParentNode: PVirtualNode; IsImport: Boolean = false);
  public
    constructor Create(const DBFilePath: string);
    destructor Destroy; override;
    procedure DoBackupList;
    procedure LoadData(Tree: TBaseVirtualTree);
    function  SaveData(Tree: TBaseVirtualTree): Boolean;
  end;

var
  DBManager: TDBManager;

const
  //Tables
  DBTable_files   = 'tbl_files';
  DBTable_version = 'tbl_version';
  DBTable_options = 'tbl_options';

  //tblOptions's fields
  DBField_options_startwithwindows   = 'startwithwindows';
  DBField_options_showpanelatstartup = 'showpanelatstartup';
  DBField_options_showmenuatstartup  = 'showmenuatstartup';
  DBField_options_language           = 'language';
  DBField_options_usecustomtitle     = 'usecustomtitle';
  DBField_options_customtitlestring  = 'customtitlestring';
  DBField_options_hidetabsearch      = 'hidetabsearch';
  DBField_options_holdsize           = 'holdsize';
  DBField_options_alwaysontop        = 'alwaysontop';
  DBField_options_listformtop        = 'listformtop';
  DBField_options_listformleft       = 'listformleft';
  DBField_options_listformwidth      = 'listformwidth';
  DBField_options_listformheight     = 'listformheight';
  DBField_options_tvbackground       = 'tvbackground';
  DBField_options_tvbackgroundpath   = 'tvbackgroundpath';
  DBField_options_tvautoopclcats     = 'tvautoopclcats';
  DBField_options_tvfont             = 'tvfont';
  DBField_options_mru                = 'mru';
  DBField_options_submenumru         = 'submenumru';
  DBField_options_mrunumber          = 'mrunumber';
  DBField_options_mfu                = 'mfu';
  DBField_options_submenumfu         = 'submenumfu';
  DBField_options_mfunumber          = 'mfunumber';
  DBField_options_backup             = 'backup';
  DBField_options_backupnumber       = 'backupnumber';
  DBField_options_autorun            = 'autorun';
  DBField_options_cache              = 'cache';
  DBField_options_actiononexe        = 'actiononexe';
  DBField_options_runsingleclick     = 'runsingleclick';
  DBField_options_trayicon           = 'trayicon';
  DBField_options_trayusecustomicon  = 'trayusecustomicon';
  DBField_options_traycustomiconpath = 'traycustomiconpath';
  DBField_options_actionclickleft    = 'actionclickleft';
  DBField_options_actionclickright   = 'actionclickright';
  //Mouse Sensors
  DBField_options_mousesensorleft    = 'mousesensorleft%d';
  DBField_options_mousesensorright   = 'mousesensorright%d';

implementation

uses
  AppConfig, ulAppConfig, ulSysUtils, ulCommonUtils, ulTreeView;

{ TDBManager }

constructor TDBManager.Create(const DBFilePath: String);
begin
  FDBFileName := DBFilePath;
  //Load sqlite3 database and create missing tables
  FSQLModel := TSQLModel.Create([TSQLtbl_version, TSQLtbl_files]);
  FDatabase := TSQLRestServerDB.Create(FSQLModel,FDBFileName);
  TSQLRestServerDB(fDatabase).CreateMissingTables(0);
end;

destructor TDBManager.Destroy;
begin
  inherited;
  FDatabase.Free;
  FSQLModel.Free;
  FDBVersion.Free;
end;

procedure TDBManager.DoBackupList;
begin
  //Backup list and old delete backup
  if (Config.Backup) then
  begin
    if not (DirectoryExists(SUITE_BACKUP_PATH)) then
      CreateDir(SUITE_BACKUP_PATH);
    CopyFile(PChar(FDBFileName),
             PChar(SUITE_BACKUP_PATH + APP_NAME + '_' + GetDateTime + EXT_SQLBCK), false);
    DeleteOldBackups(Config.BackupNumber);
  end;
end;

procedure TDBManager.InternalLoadData(Tree: TBaseVirtualTree;
  IsImport: Boolean = false);
begin
  try
    //Load Database version
    InternalLoadVersion;
    if Not(IsImport) then
    begin
      //InternalLoadOptions;
      MRUList := TMRUList.Create(Config.MRUNumber);
      MFUList := TMFUList.Create(Config.MFUNumber);
    end;
    InternalLoadListItems(Tree, 0, nil, IsImport);
  except
    on E : Exception do
      ShowMessageFmt(msgErrGeneric,[E.ClassName,E.Message]);
  end;
end;

procedure TDBManager.InternalLoadListItems(Tree: TBaseVirtualTree; ID: Integer;
  ParentNode: PVirtualNode; IsImport: Boolean = false);
var
  SQLFilesData : TSQLtbl_files;
  nType    : TvTreeDataType;
  vData    : TvBaseNodeData;
  Node     : PVirtualNode;
begin
  //Get files from DBTable and order them by parent, position
  SQLFilesData := TSQLtbl_files.CreateAndFillPrepare(FDatabase,'parent=? ORDER BY parent, position',[ID]);
  try
    //Get files and its properties
    while SQLFilesData.FillOne do
    begin
      nType := TvTreeDataType(SQLFilesData.itemtype);
      Node  := Tree.AddChild(ParentNode, CreateNodeData(nType));
      vData := PBaseData(Tree.GetNodeData(Node)).Data;
      PBaseData(Tree.GetNodeData(Node)).pNode := Node;
      if IsImport then
        Tree.CheckType[Node] := ctTriStateCheckBox
      else
        vData.CacheID     := SQLFilesData.cacheicon_id;
      // generic fields
      vData.Name          := UTF8ToString(SQLFilesData.title);
      vData.id            := SQLFilesData.ID;
      vData.ParentID      := id;
      vData.Position      := Node.Index;
      vData.UnixAddDate   := SQLFilesData.dateAdded;
      vData.UnixEditDate  := SQLFilesData.lastModified;
      vData.ParentNode    := ParentNode;
      vData.PathIcon      := UTF8ToString(SQLFilesData.icon_path);
      vData.HideFromMenu  := SQLFilesData.hide_from_menu;
      if (nType = vtdtFile) then
      begin
        with TvFileNodeData(vData) do
        begin
          PathExe          := UTF8ToString(SQLFilesData.path);
          Parameters       := UTF8ToString(SQLFilesData.parameters);
          WorkingDir       := UTF8ToString(SQLFilesData.work_path);
          ClickCount       := SQLFilesData.clicks;
          ShortcutDesktop  := SQLFilesData.dsk_shortcut;
          AutorunPos       := SQLFilesData.autorun_position;
          Autorun          := TAutorunType(SQLFilesData.autorun);
          WindowState      := SQLFilesData.window_state;
          ActionOnExe      := TActionOnExecution(SQLFilesData.onlaunch);
          NoMRU            := SQLFilesData.no_mru;
          NoMFU            := SQLFilesData.no_mfu;
          MRUPosition      := SQLFilesData.lastAccess;
        end;
      end;
      if (nType = vtdtCategory) then
        InternalLoadListItems(Tree, vData.ID, Node);
    end;
  finally
    SQLFilesData.Free;
  end;
end;

procedure TDBManager.LoadData(Tree: TBaseVirtualTree);
begin
  //List & Options
  DBManager.InternalLoadData(Tree);
  //Backup sqlite database
  DBManager.DoBackupList;
  //Get rootnode's Icons
  GetChildNodesIcons(Tree, Tree.RootNode);
end;

procedure TDBManager.InternalLoadVersion;
var
  VersionData: TSQLtbl_version;
begin
  if FDatabase.TableHasRows(TSQLtbl_version) then
  begin
    //Get sql data and get version info
    VersionData := TSQLtbl_version.Create;
    try
      FDatabase.Retrieve(1, VersionData);
      //Create FDBVersion with db version info
      FDBVersion := TVersionInfo.Create(VersionData.Major,
                                        VersionData.Minor,
                                        VersionData.Release,
                                        VersionData.Build);
    finally
      VersionData.Free;
    end;
  end
  else begin
    //Create FDBVersion with actual ASuite version info
    FDBVersion := TVersionInfo.Create;
  end;
end;

function TDBManager.SaveData(Tree: TBaseVirtualTree): Boolean;
begin
  Result := True;
  //If launcher is in ReadOnlyMode, exit from this function
  if (Config.ReadOnlyMode) then
    Exit;
  //List & Options
  try
    //DBManager.SaveData(Tree,Tree.GetFirst,0);
  except
    Result := False;
  end;
end;

initialization

finalization
  DBManager.Free

end.
