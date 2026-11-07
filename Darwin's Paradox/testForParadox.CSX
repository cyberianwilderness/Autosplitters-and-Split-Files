
<Structures>
  <Structure Name="BP_DarwinGameInstance_C" AutoFill="0" AutoCreate="1" DefaultHex="0" AutoDestroy="0" DoNotSaveLocal="0" RLECompression="1" AutoCreateStructsize="4096">
    <Elements>
      <Element Offset="0" Vartype="Pointer" Bytesize="8" OffsetHex="00000000" Description="vftable" DisplayMethod="unsigned integer"/>
      <Element Offset="16" Vartype="Pointer" Bytesize="8" OffsetHex="00000010" ChildStruct="UClass" Description="Class" DisplayMethod="unsigned integer" PreviewPriority="2"/>
      <Element Offset="24" Vartype="Custom" Bytesize="8" OffsetHex="00000018" Customtype="UE FName to String" Description="Name" DisplayMethod="unsigned integer" PreviewPriority="1"/>
      <Element Offset="56" Vartype="Pointer" Bytesize="8" OffsetHex="00000038" Description="LocalPlayers" DisplayMethod="unsigned integer"/>
      <Element Offset="72" Vartype="Pointer" Bytesize="8" OffsetHex="00000048" Description="OnlineSession" DisplayMethod="unsigned integer"/>
      <Element Offset="80" Vartype="Pointer" Bytesize="8" OffsetHex="00000050" Description="ReferencedObjects" DisplayMethod="unsigned integer"/>
      <Element Offset="120" Vartype="Pointer" Bytesize="8" OffsetHex="00000078" Description="OnPawnControllerChangedDelegates" DisplayMethod="unsigned integer"/>
      <Element Offset="160" Vartype="Pointer" Bytesize="8" OffsetHex="000000A0" Description="OnInputDeviceConnectionChange" DisplayMethod="unsigned integer"/>
      <Element Offset="176" Vartype="Pointer" Bytesize="8" OffsetHex="000000B0" Description="OnUserInputDevicePairingChange" DisplayMethod="unsigned integer"/>
      <Element Offset="472" Vartype="Pointer" Bytesize="8" OffsetHex="000001D8" ChildStruct="widestring" Description="BuildName" DisplayMethod="unsigned integer"/>
      <Element Offset="488" Vartype="Float" Bytesize="4" OffsetHex="000001E8" Description="FrameRateCaptureInterval" DisplayMethod="unsigned integer"/>
      <Element Offset="496" Vartype="Pointer" Bytesize="8" OffsetHex="000001F0" ChildStruct="UClass" Description="WorldManagerClass" DisplayMethod="unsigned integer"/>
      <Element Offset="504" Vartype="Pointer" Bytesize="8" OffsetHex="000001F8" ChildStruct="UClass" Description="SkinSystemClass" DisplayMethod="unsigned integer"/>
      <Element Offset="512" Vartype="Pointer" Bytesize="8" OffsetHex="00000200" ChildStruct="UClass" Description="DatastoreClass" DisplayMethod="unsigned integer"/>
      <Element Offset="520" Vartype="Pointer" Bytesize="8" OffsetHex="00000208" ChildStruct="UClass" Description="TrophySystemClass" DisplayMethod="unsigned integer"/>
      <Element Offset="528" Vartype="Pointer" Bytesize="8" OffsetHex="00000210" ChildStruct="UClass" Description="PlayerEventListenerSystemClass" DisplayMethod="unsigned integer"/>
      <Element Offset="536" Vartype="Pointer" Bytesize="8" OffsetHex="00000218" ChildStruct="UClass" Description="SaveManagerClass" DisplayMethod="unsigned integer"/>
      <Element Offset="544" Vartype="Pointer" Bytesize="8" OffsetHex="00000220" ChildStruct="UClass" Description="UIControllerClass" DisplayMethod="unsigned integer"/>
      <Element Offset="552" Vartype="Pointer" Bytesize="8" OffsetHex="00000228" ChildStruct="UClass" Description="SubtitleSystemClass" DisplayMethod="unsigned integer"/>
      <Element Offset="560" Vartype="Pointer" Bytesize="8" OffsetHex="00000230" ChildStruct="UClass" Description="CollisionAvoidanceSystemClass" DisplayMethod="unsigned integer"/>
      <Element Offset="568" Vartype="Pointer" Bytesize="8" OffsetHex="00000238" Description="DeathFactory" DisplayMethod="unsigned integer"/>
      <Element Offset="576" Vartype="Pointer" Bytesize="8" OffsetHex="00000240" Description="PostProcessMaterialCollection" DisplayMethod="unsigned integer"/>
      <Element Offset="584" Vartype="Pointer" Bytesize="8" OffsetHex="00000248" Description="OnFocus" DisplayMethod="unsigned integer"/>
      <Element Offset="600" Vartype="Pointer" Bytesize="8" OffsetHex="00000258" Description="OnInputModeChanged" DisplayMethod="unsigned integer"/>
      <Element Offset="616" Vartype="Pointer" Bytesize="8" OffsetHex="00000268" Description="OnGameplayReady" DisplayMethod="unsigned integer"/>
      <Element Offset="632" Vartype="Pointer" Bytesize="8" OffsetHex="00000278" Description="OnRenderingEvent" DisplayMethod="unsigned integer"/>
      <Element Offset="648" Vartype="Pointer" Bytesize="8" OffsetHex="00000288" Description="OnControllerConnected" DisplayMethod="unsigned integer"/>
      <Element Offset="664" Vartype="Pointer" Bytesize="8" OffsetHex="00000298" Description="OnLoadCompleted" DisplayMethod="unsigned integer"/>
      <Element Offset="680" Vartype="Pointer" Bytesize="8" OffsetHex="000002A8" ChildStruct="Class" Description="OnLevelTransitionFinished" DisplayMethod="unsigned integer"/>
      <Element Offset="696" BitSize="1" Vartype="Binary" BitStart="0" Bytesize="1" OffsetHex="000002B8" Description="bIsLoadingGame" DisplayMethod="unsigned integer"/>
      <Element Offset="704" Vartype="Pointer" Bytesize="8" OffsetHex="000002C0" Description="SaveManager" DisplayMethod="unsigned integer"/>
      <Element Offset="712" Vartype="Pointer" Bytesize="8" OffsetHex="000002C8" Description="UIController" DisplayMethod="unsigned integer"/>
      <Element Offset="720" Vartype="Pointer" Bytesize="8" OffsetHex="000002D0" Description="SubtitleSystem" DisplayMethod="unsigned integer"/>
      <Element Offset="728" Vartype="Pointer" Bytesize="8" OffsetHex="000002D8" Description="TrophySystem" DisplayMethod="unsigned integer"/>
      <Element Offset="736" Vartype="Pointer" Bytesize="8" OffsetHex="000002E0" Description="WorldManager" DisplayMethod="unsigned integer"/>
      <Element Offset="744" Vartype="Pointer" Bytesize="8" OffsetHex="000002E8" Description="SkinSystem" DisplayMethod="unsigned integer"/>
      <Element Offset="752" Vartype="Pointer" Bytesize="8" OffsetHex="000002F0" Description="Datastore" DisplayMethod="unsigned integer"/>
      <Element Offset="760" Vartype="Pointer" Bytesize="8" OffsetHex="000002F8" Description="CollisionAvoidanceSystem" DisplayMethod="unsigned integer"/>
      <Element Offset="768" Vartype="Pointer" Bytesize="8" OffsetHex="00000300" Description="PlayerEventListenerSystem" DisplayMethod="unsigned integer"/>
      <Element Offset="776" BitSize="1" Vartype="Binary" BitStart="0" Bytesize="1" OffsetHex="00000308" Description="bIsGameplayReady" DisplayMethod="unsigned integer"/>
      <Element Offset="784" Vartype="Array of byte" Bytesize="32" OffsetHex="00000310" Description="GameFacts" DisplayMethod="unsigned integer"/>
      <Element Offset="816" Vartype="Pointer" Bytesize="8" OffsetHex="00000330" Description="ActiveWidgets" DisplayMethod="unsigned integer"/>
      <Element Offset="832" Vartype="Pointer" Bytesize="8" OffsetHex="00000340" Description="CheckPoints" DisplayMethod="unsigned integer"/>
      <Element Offset="848" Vartype="Pointer" Bytesize="8" OffsetHex="00000350" Description="PlatformType" DisplayMethod="unsigned integer"/>
      <Element Offset="849" Vartype="Pointer" Bytesize="8" OffsetHex="00000351" Description="inputMode" DisplayMethod="unsigned integer"/>
      <Element Offset="852" Vartype="Array of byte" Bytesize="16" OffsetHex="00000354" Description="RequestedCheckpoint" DisplayMethod="unsigned integer"/>
      <Element Offset="872" Vartype="Pointer" Bytesize="8" OffsetHex="00000368" ChildStruct="UClass" Description="CollectibleSystemClass" DisplayMethod="unsigned integer"/>
      <Element Offset="880" Vartype="Pointer" Bytesize="8" OffsetHex="00000370" Description="CollectibleSystem" DisplayMethod="unsigned integer"/>
      <Element Offset="888" Vartype="Pointer" Bytesize="8" OffsetHex="00000378" ChildStruct="UClass" Description="AIDirectorClass" DisplayMethod="unsigned integer"/>
      <Element Offset="896" Vartype="Pointer" Bytesize="8" OffsetHex="00000380" Description="AIDirector" DisplayMethod="unsigned integer"/>
      <Element Offset="904" Vartype="Pointer" Bytesize="8" OffsetHex="00000388" Description="ActorLogs" DisplayMethod="unsigned integer"/>
      <Element Offset="984" BitSize="1" Vartype="Binary" BitStart="0" Bytesize="1" OffsetHex="000003D8" Description="bIsMGSDemo" DisplayMethod="unsigned integer"/>
      <Element Offset="985" BitSize="1" Vartype="Binary" BitStart="0" Bytesize="1" OffsetHex="000003D9" Description="bIsPauseMenuLocked" DisplayMethod="unsigned integer"/>
      <Element Offset="1056" Vartype="Array of byte" Bytesize="8" OffsetHex="00000420" Description="UberGraphFrame" DisplayMethod="unsigned integer"/>
      <Element Offset="1064" Vartype="Pointer" Bytesize="8" OffsetHex="00000428" Description="AudioDeviceEvents" DisplayMethod="unsigned integer"/>
      <Element Offset="1080" BitSize="1" Vartype="Binary" BitStart="0" Bytesize="1" OffsetHex="00000438" Description="HasSeenLogos" DisplayMethod="unsigned integer"/>
      <Element Offset="1081" BitSize="1" Vartype="Binary" BitStart="0" Bytesize="1" OffsetHex="00000439" Description="HasStartedGame" DisplayMethod="unsigned integer"/>
      <Element Offset="1082" BitSize="1" Vartype="Binary" BitStart="0" Bytesize="1" OffsetHex="0000043A" Description="IsPlayingMainTheme" DisplayMethod="unsigned integer"/>
    </Elements>
  </Structure>
</Structures>