%% Main Script GUI -- Basketballwurf
% Fuehre dieses Skript im Ordner aus, in dem die Dateien 'basketball.png'
% und 'korb.png' enthalten sind. Damit der Basketballwurf simuliert werden
% kann muessen z usaetzlich die Funktionen zur Trajektorien Berechnung
% expEul, expEulLW, heun, heunLW, rkf23 und rkf23LW ausgefuellt und die
% Dateien dazu im gleichen Ordner vorhanden sein.

%=========================================================================
% In dieser Datei muss nichts veraendert werden.
%=========================================================================

[bball, ~, alpha1] = imread('basketball.png');
[korb, ~, alpha2] = imread('korb.png');
% Eingabe der Werte
abwurfEntfernung = 3;
abwurfHoehe = 2;
abwurfWinkel = 45;
abwurfGeschw = 5;
abwurfDaempf = 0.9;

if ishandle(100)
    close 100
end
figIntAct = figure(100);
set(0,'CurrentFigure',100)
clf
intActPlot(bball,alpha1,korb,alpha2,abwurfEntfernung,abwurfHoehe,...
    abwurfWinkel,abwurfGeschw,abwurfDaempf,figIntAct)

function intActPlot(bball,alpha1,korb,alpha2,initX,initY,initAng,...
    initVel,initDae,currFig)
pos = [0.05 0.3 0.9 0.55];
currAx = axes('Position',pos);
plotInitSit(bball,alpha1,korb,alpha2,initX,initY,initAng,initVel)
posTitle=[pos(1) pos(2)+pos(4)+0.01 pos(3) 0.05];
posXSld=[pos(1) pos(2)-0.1 pos(3)/4-pos(1) 0.05];
posTtX =posXSld-[0 0.05 0 0];
posYSld=[pos(3)/4+pos(1) pos(2)-0.1 pos(3)/4-pos(1) 0.05];
posTtY =posYSld-[0 0.05 0 0];
posAngSld=[2*pos(3)/4+pos(1) pos(2)-0.1 pos(3)/4-pos(1) 0.05];
posTtAng =posAngSld-[0 0.05 0 0];
posVelSld=[3*pos(3)/4+pos(1) pos(2)-0.1 pos(3)/4-pos(1) 0.05];
posTtVel =posVelSld-[0 0.05 0 0];
posDaeSld=[pos(1) pos(2)-0.2 pos(3)/4-pos(1) 0.05];
posMthdCh=[pos(3)/4+pos(1) pos(2)-0.2 pos(3)/4-pos(1) 0.05];
posTtDae =posDaeSld-[0 0.05 0 0];
posButton = [0.75 0.1 0.15 0.05];
poscbFNM = [0.5 0.1 0.1 0.05];
poscbLW = [0.6 0.1 0.15 0.05];
mthdNb = 1;
airVel = 0;

blString = blStringFunc(mthdNb,airVel,initX,initY,initAng,initVel,initDae);

bl1 = uicontrol('Parent',currFig,'Style','text','Units','normalized',...
    'Position',posTitle,'String',blString,'FontSize',12,'FontWeight','bold');
popM = uicontrol("Style","popupmenu","String",{'Exp. Euler','Heun','RKF2(3)'},'Units','normalized',...
    'Position',posMthdCh,'Value',1,'Callback',@(src,events) mthdCh(bball,alpha1,korb,alpha2,src,bl1));
uicontrol('Style','pushbutton','String','Wurf!','Units','normalized',...
    'Position',poscbFNM,'Callback',@(src,event) cbFavNumMethFunc(bl1,false,popM.Value) );
uicontrol('Style','pushbutton','String','Wurf mit Luftwiderstand!','Units','normalized',...
    'Position',poscbLW,'Callback',@(src,event) cbFavNumMethFunc(bl1,true,popM.Value) );
uicontrol('Parent',currFig,'Style','pushbutton','String','Wurf speichern!','Units','normalized',...
    'Position',posButton,'Callback',@(src,event) buttonPushed(currAx,currFig,bl1,pos) );
ttX = uicontrol('Parent',currFig,'Style','text','Units','normalized','Position',posTtX,...
    'String',['Entfernung: ' num2str(initX) 'm']);
uicontrol('style','slider','units','normalized','position',posXSld,...
    'Callback',@(sld,event) updSliderX(bball,alpha1,korb,alpha2,event,bl1,ttX,popM.Value), ...
    'min',0,'max',50,'Value',initX,'SliderStep',[1/100 1/10]);
ttY = uicontrol('Parent',currFig,'Style','text','Units','normalized','Position',posTtY,...
    'String',['Hoehe: ' num2str(initY) 'm']);
uicontrol('style','slider','units','normalized','position',posYSld,...
    'Callback',@(sld,event) updSliderY(bball,alpha1,korb,alpha2,event,bl1,ttY,popM.Value), ...
    'min',1.5,'max',3,'Value',initY,'SliderStep',[1/30 1/5]);
ttAng = uicontrol('Parent',currFig,'Style','text','Units','normalized','Position',posTtAng,...
    'String',['Winkel: ' num2str(initAng) '°']);
uicontrol('style','slider','units','normalized','position',posAngSld,...
    'Callback',@(sld,event) updSliderAng(bball,alpha1,korb,alpha2,event,bl1,ttAng,popM.Value), ...
    'min',0,'max',90,'Value',initAng,'SliderStep',[1/90 1/9]);
ttVel = uicontrol('Parent',currFig,'Style','text','Units','normalized','Position',posTtVel,...
    'String',['Geschwindigkeit: ' num2str(initVel) 'm/s']);
uicontrol('style','slider','units','normalized','position',posVelSld,...
    'Callback',@(sld,event) updSliderVel(bball,alpha1,korb,alpha2,event,bl1,ttVel,popM.Value), ...
    'min',0,'max',10,'Value',initVel,'SliderStep',[1/100 1/10]);
ttDae = uicontrol('Parent',currFig,'Style','text','Units','normalized','Position',posTtDae,...
    'String',['Daempfung: ' num2str(initDae)]);
uicontrol('style','slider','units','normalized','position',posDaeSld,...
    'Callback',@(sld,event) updSliderDae(bball,alpha1,korb,alpha2,event,bl1,ttDae,popM.Value), ...
    'min',0,'max',1,'Value',initDae,'SliderStep',[1/100 1/10]);
end

function plotInitSit(bball,alpha1,korb,alpha2,initX,initY,initAng,initVel)
cla
hold on
% Position von bball (Bild:10x28cm, MP des Balls:(50.09,249.61)
xRelbball = 50.09/100;
yRelbball = 249.61/280;
bballPosX = -initX + initY/yRelbball/2.8*[-xRelbball (1-xRelbball)];
bballPosY = [initY/yRelbball 0];
imagesc(bballPosX, bballPosY, bball,'AlphaData',alpha1);
% Position des Korbes (Bild:21x25cm, MP des Rings:(55.81,95.43)
korbEntfernung = 0;
korbHoehe = 3.05;
xRelKorb = 55.81/210;
yRelKorb = 95.43/250;
korbMinY = 2.5;
korbPosX = korbEntfernung + (korbHoehe-korbMinY)/yRelKorb/(250/210)*[-xRelKorb (1-xRelKorb)];
korbPosY = korbMinY + [(korbHoehe-korbMinY)/yRelKorb 0];
imagesc(korbPosX, korbPosY, korb,'AlphaData',alpha2);
% Zusätzliche Linien und Markierungen
quiver(-initX,initY,cos(initAng/180*pi),sin(initAng/180*pi),0.1+initVel/10,'g','LineWidth',2)
plot(-initX,initY,'g+','MarkerSize',5,'LineWidth',3)
plot([-initX,0],[3.05 3.05],'k+--')
plot([-0.2 0.2],[3.05 3.05],'r+-','MarkerSize',5,'LineWidth',3)
xticks([-28.65 -14.325 -7.24 -4.5 0])
xticklabels({'Ganzes Feld','Halbes Feld','3-Punkte','Freiwurf','Korbmitte'})
hold off
axis equal
end

function titleStr = blStringFunc(mthdNb,airVel,X,Y,Ang,Vel,Dae)
switch mthdNb
    case 1
        ttMthd = 'Methode: Exp. Euler; ';
    case 2
        ttMthd = 'Methode: Heun; ';
    case 3
        ttMthd = 'Methode: RKF2(3); ';
end
titleStr = {[ttMthd 'Luftgeschwindigkeit: ' num2str(airVel,2) 'm/s'] ['Entfernung: ' num2str(X) ...
    'm, Hoehe: '  num2str(Y) 'm, Winkel: ' num2str(Ang) ...
    '°, Geschwindigkeit: ' num2str(Vel) 'm/s, Daempfung: ' num2str(Dae) ]};
end

function mthdCh(bball,alpha1,korb,alpha2,src,bl1)
titleCell = bl1.String;
titleStr = titleCell{2};
oldX = eval(cell2mat(extractBetween(titleStr,"Entfernung: ","m")));
oldY = eval(cell2mat(extractBetween(titleStr,"Hoehe: ","m")));
oldAng = eval(cell2mat(extractBetween(titleStr,"Winkel: ","°")));
oldVel = eval(cell2mat(extractBetween(titleStr,"Geschwindigkeit: ","m/s")));
oldDae = eval(extractAfter(titleStr,"Daempfung: "));
plotInitSit(bball,alpha1,korb,alpha2,oldX,oldY,oldAng,oldVel)
bl1.String = blStringFunc(src.Value,0,oldX,oldY,oldAng,oldVel,oldDae);
end

function updSliderX(bball,alpha1,korb,alpha2,sliderEv,bl1,ttX,mthdNb)
titleCell = bl1.String;
titleStr = titleCell{2};
newX = sliderEv.Source.Value;
oldY = eval(cell2mat(extractBetween(titleStr,"Hoehe: ","m")));
oldAng = eval(cell2mat(extractBetween(titleStr,"Winkel: ","°")));
oldVel = eval(cell2mat(extractBetween(titleStr,"Geschwindigkeit: ","m/s")));
oldDae = eval(extractAfter(titleStr,"Daempfung: "));
plotInitSit(bball,alpha1,korb,alpha2,newX,oldY,oldAng,oldVel)
bl1.String = blStringFunc(mthdNb,0,newX,oldY,oldAng,oldVel,oldDae);
ttX.String = ['Entfernung: ' num2str(newX) 'm'];
end

function updSliderY(bball,alpha1,korb,alpha2,sliderEv,bl1,ttY,mthdNb)
titleCell = bl1.String;
titleStr = titleCell{2};
oldX = eval(cell2mat(extractBetween(titleStr,"Entfernung: ","m")));
newY = sliderEv.Source.Value;
oldAng = eval(cell2mat(extractBetween(titleStr,"Winkel: ","°")));
oldVel = eval(cell2mat(extractBetween(titleStr,"Geschwindigkeit: ","m/s")));
oldDae = eval(extractAfter(titleStr,"Daempfung: "));
plotInitSit(bball,alpha1,korb,alpha2,oldX,newY,oldAng,oldVel)
bl1.String = blStringFunc(mthdNb,0,oldX,newY,oldAng,oldVel,oldDae);
ttY.String = ['Hoehe: ' num2str(newY) 'm'];
end

function updSliderAng(bball,alpha1,korb,alpha2,sliderEv,bl1,ttAng,mthdNb)
titleCell = bl1.String;
titleStr = titleCell{2};
oldX = eval(cell2mat(extractBetween(titleStr,"Entfernung: ","m")));
oldY = eval(cell2mat(extractBetween(titleStr,"Hoehe: ","m")));
newAng = sliderEv.Source.Value;
oldVel = eval(cell2mat(extractBetween(titleStr,"Geschwindigkeit: ","m/s")));
oldDae = eval(extractAfter(titleStr,"Daempfung: "));
plotInitSit(bball,alpha1,korb,alpha2,oldX,oldY,newAng,oldVel)
bl1.String = blStringFunc(mthdNb,0,oldX,oldY,newAng,oldVel,oldDae);
ttAng.String = ['Winkel: ' num2str(newAng) '°'];
end

function updSliderVel(bball,alpha1,korb,alpha2,sliderEv,bl1,ttVel,mthdNb)
titleCell = bl1.String;
titleStr = titleCell{2};
oldX = eval(cell2mat(extractBetween(titleStr,"Entfernung: ","m")));
oldY = eval(cell2mat(extractBetween(titleStr,"Hoehe: ","m")));
oldAng = eval(cell2mat(extractBetween(titleStr,"Winkel: ","°")));
newVel = sliderEv.Source.Value;
oldDae = eval(extractAfter(titleStr,"Daempfung: "));
plotInitSit(bball,alpha1,korb,alpha2,oldX,oldY,oldAng,newVel)
bl1.String = blStringFunc(mthdNb,0,oldX,oldY,oldAng,newVel,oldDae);
ttVel.String = ['Geschwindigkeit: ' num2str(newVel) 'm/s'];
end

function updSliderDae(bball,alpha1,korb,alpha2,sliderEv,bl1,ttDae,mthdNb)
titleCell = bl1.String;
titleStr = titleCell{2};
oldX = eval(cell2mat(extractBetween(titleStr,"Entfernung: ","m")));
oldY = eval(cell2mat(extractBetween(titleStr,"Hoehe: ","m")));
oldAng = eval(cell2mat(extractBetween(titleStr,"Winkel: ","°")));
oldVel = eval(cell2mat(extractBetween(titleStr,"Geschwindigkeit: ","m/s")));
newDae = sliderEv.Source.Value;
plotInitSit(bball,alpha1,korb,alpha2,oldX,oldY,oldAng,oldVel)
bl1.String = blStringFunc(mthdNb,0,oldX,oldY,oldAng,oldVel,newDae);
ttDae.String = ['Daempfung: ' num2str(newDae)];
end

function cbFavNumMethFunc(bl1,boolcbLW,mthdNb)
titleCell = bl1.String;
titleStr = titleCell{2};
oldX = eval(cell2mat(extractBetween(titleStr,"Entfernung: ","m")));
oldY = eval(cell2mat(extractBetween(titleStr,"Hoehe: ","m")));
oldAng = eval(cell2mat(extractBetween(titleStr,"Winkel: ","°")));
oldVel = eval(cell2mat(extractBetween(titleStr,"Geschwindigkeit: ","m/s")));
oldDae = eval(extractAfter(titleStr,"Daempfung: "));
if boolcbLW
    switch mthdNb
        case 1
            [XX,airVel] = expEulLW(-oldX,oldY,oldAng/180*pi,oldVel,oldDae);
        case 2
            [XX,airVel] = heunLW(-oldX,oldY,oldAng/180*pi,oldVel,oldDae);
        case 3
            [XX,airVel] = rkf23LW(-oldX,oldY,oldAng/180*pi,oldVel,oldDae);
    end
    plotLineStl = "mo";
    bl1.String = blStringFunc(mthdNb,airVel,oldX,oldY,oldAng,oldVel,oldDae);
else
    switch mthdNb
        case 1
            XX = expEul(-oldX,oldY,oldAng/180*pi,oldVel,oldDae);
        case 2
            XX = heun(-oldX,oldY,oldAng/180*pi,oldVel,oldDae);
        case 3
            XX = rkf23(-oldX,oldY,oldAng/180*pi,oldVel,oldDae);
    end
    plotLineStl = "b*";
end
plotTrajectory(XX,plotLineStl);
end

function plotTrajectory(XX,plotLineStl)
hold on
plot(XX(1,:),XX(2,:),plotLineStl)
hold off
end

function buttonPushed(currAx,currFig,bl1,pos)
numFS = get(0,'defaultAxesFontSize');
figure(999)
clf
set(figure(999),'Color','White')
set(0,'defaultAxesFontSize',20)
copyobj(currAx,figure(999))
titleStr = bl1.String;
title(titleStr,'FontSize',20,'FontWeight','normal')
imgTitle = 'wurf1.png';
while exist(imgTitle, 'file')
    nb = eval(cell2mat(extractBetween(imgTitle,"wurf",".png")));
    imgTitle = ['wurf' num2str(nb+1) '.png'];
end
saveas(figure(999),imgTitle)
set(0,'defaultAxesFontSize',numFS)
I = imread(imgTitle);
siI = size(I);
cutInd = round([(1-pos(2)-pos(4)-0.08) (1-pos(2)+0.05)]*siI(1),0);
I2 = I(cutInd(1):cutInd(2),:,:);
imwrite(I2,imgTitle)
close 999
set(0,'CurrentFigure',currFig)
fprintf('%s wurde gespeichert!\n',imgTitle)
end
