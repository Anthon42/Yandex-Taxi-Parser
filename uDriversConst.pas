unit uDriversConst;

interface

uses uDriversTypes;

const
  constBingAPIKey: string = 'ArlyKldofYxmTMOXnHlmlQ-fbUJHSKAQlI6HRo_owmWYBYsPSwJ-6bwL2uI_P17B';

  constCenterMoscowTopLeftLatitude = 55.767664;
  constCenterMoscowTopLeftLongitude = 37.596977;

  constCenterMoscowRightLatitude = 55.744125;
  constCenterMoscowRightLongitude = 37.658476;

  // Координаты углов прямоугольника, в котором будет происходить поиск водителей
  constTopLeftPosition: TZonePosition = (Latitude: 55.927083; Longitude: 37.329993);
  constBottomRightPosition: TZonePosition = (Latitude: 55.552885; Longitude: 37.910895);
  // Количество делений зоны
  constMaskSize = 25;
  // Типы тарифов такси
  constPrimierClass = 'ultimate';
  constEleteClass = 'maybach';

implementation

end.
