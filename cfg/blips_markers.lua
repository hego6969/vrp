-- this file is used to define additional static blips and markers to the map
-- some lists: https://wiki.gtanet.work/index.php?title=Blips

local cfg = {}

-- list of blips
-- {x,y,z,idtype,idcolor,text}
cfg.blips = {
	-- FITNESS --
	{-1202.96252441406,-1566.14086914063,4.61040639877319,311,17,"Fitness World"},

	-- POLITISTATIONER --
	{1853.21,3689.51,34.2671,60,29,"Politistation"},
	{442.1178894043,-978.85797119141,30.689594268799,60,29,"Politistation"},
	{-449.5608215332,6012.2993164063,31.716381072998,60,29,"Politistation"},



    -- Bryd Håndjern op --
  {1228.1469726563,2742.337890625,37.105340576172,188,1,"Bryd Håndjern Op"},
  {-56.670337677002,-2520.1564941406,6.5011688232422,188,1,"Bryd Håndjern Op"},
  {2526.345703125,4990.0068359375,43.86118850708,188,1,"Bryd Håndjern Op"},
 
	-- Steel

	-- SKOVHUGGER JOB --
	--{-1586.6834716797,4700.263671875,45.322353363037,478,21,"Hug træ"},
	--{-525.5380859375,5290.7846679688,74.174438476563,478,21,"Lav Planker"},
	--{27.032907485962,3636.0126953125,40.029407501221,478,21,"Salg af Planker"},


	-- HOSPITAL --
	{299.94345092773,-584.87231445313,43.291854858398,153,6,"Hospitalet"},
    {-246.8889465332,6331.2026367188,32.426239013672,153,6,"Hospitalet"}, --Paleto
	
	--Fængsel
	{1690.5877685546,2604.4914550782,45.564846038818,285,39,"Fængsel"},
	{1729.3077392578,2563.1813964844,45.564849853516,50,39,"Lager"},
	{1641.8634033203,2530.0207519531,45.564880371094,311,39,"Styrke Træning"},
	
	{935.84332275391,46.965873718262,81.095794677734,679,48,"Casino"}, -- casino
    -- Stripklub --
	{119.0786895752,-1289.8216552734,51.578205108643,121,48,"Stripklub"},
}
-- list of markers
-- {x,y,z,sx,sy,sz,r,g,b,a,visible_distance}
cfg.markers = {
}

return cfg
