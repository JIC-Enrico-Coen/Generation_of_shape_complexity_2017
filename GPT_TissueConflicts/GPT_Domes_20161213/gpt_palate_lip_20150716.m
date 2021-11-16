function m = gpt_palate_lip_20150716( m )
%m = gpt_palate_lip_20150716( m )
%   Morphogen interaction function.
%   Written at 2015-10-09 16:58:32.
%   GFtbox revision 5290, 2015-09-08 16:43.

% The user may edit any part of this function between delimiters
% of the form "USER CODE..." and "END OF USER CODE...".  The
% delimiters themselves must not be moved, edited, deleted, or added.

    if isempty(m), return; end

    fprintf( 1, '%s found in %s\n', mfilename(), which(mfilename()) );

    try
        m = local_setproperties( m );
    catch
    end

    setGlobals();
    realtime = m.globalDynamicProps.currenttime;
    dt = m.globalProps.timestep;

%%% USER CODE: INITIALISATION

% In this section you may modify the mesh in any way whatsoever.
if (Steps(m)==0) && m.globalDynamicProps.doinit % First iteration
      
    % Set up names for variant models.  Useful for running multiple models on a cluster.
    m.userdata.ranges.modelname.range = { 'MODEL1', 'MODEL2', 'MODEL3', 'MODEL4','MODEL4a', 'MODEL5', 'MODEL6', 'MODEL6_div', 'MODEL7'};  % CLUSTER
    m.userdata.ranges.modelname.index =7;                       % CLUSTER
    
    m = leaf_setzeroz( m );
   % m = leaf_perturbz( m, 0.05, 'absolute', false ); %0.1
    m = leaf_bowlz(m, 0.08 );
    m = leaf_setthickness(m, 0.06);
    
    
   % m = leaf_fix_vertex( m, 'vertex', find(m.nodes(:,1)<=min(m.nodes(:,1)+0.01)), 'dfs', 'yz' );
    %m = leaf_fix_vertex( m, 'vertex', find(m.nodes(:,1)>=max(m.nodes(:,1)-0.01)), 'dfs', 'z' );
    
    %m = leaf_fix_vertex( m, 'vertex', find(m.nodes(:,1)<=min(m.nodes(:,1)+0.01)), 'dfs', 'xyz' );
    %m = leaf_fix_vertex( m, 'vertex', find(m.nodes(:,1)>=max(m.nodes(:,1)-0.01)), 'dfs', 'xyz' );
    
    % set colour of polariser gradient arrows
    m=leaf_plotoptions(m,'highgradcolor',[0,0,0],'lowgradcolor',[0,0,0]);
    m=leaf_plotoptions(m,'decorscale',1.5);
    m=leaf_plotoptions(m,'arrowthickness',1.3);
    
    m.globalProps.timestep=1;
    
end
modelname = m.userdata.ranges.modelname.range{m.userdata.ranges.modelname.index};  % CLUSTER
disp(sprintf('model2',mfilename, modelname));
switch modelname
    case {'MODEL1','MODEL2'}
       
    otherwise
        % If you reach here, you probably forgot a case.
end
%%% END OF USER CODE: INITIALISATION

%%% SECTION 1: ACCESSING MORPHOGENS AND TIME.
%%% AUTOMATICALLY GENERATED CODE: DO NOT EDIT.

    global gNEW_KA_PAR gNEW_KA_PER gNEW_KB_PAR gNEW_KB_PER
    global gNEW_K_NOR gNEW_POLARISER gNEW_STRAINRET gNEW_ARREST
    polariser_i = gNEW_POLARISER;
    P = m.morphogens(:,polariser_i);
    [kapar_i,kapar_p,kapar_a,kapar_l] = getMgenLevels( m, 'KAPAR' );
    [kaper_i,kaper_p,kaper_a,kaper_l] = getMgenLevels( m, 'KAPER' );
    [kbpar_i,kbpar_p,kbpar_a,kbpar_l] = getMgenLevels( m, 'KBPAR' );
    [kbper_i,kbper_p,kbper_a,kbper_l] = getMgenLevels( m, 'KBPER' );
    [knor_i,knor_p,knor_a,knor_l] = getMgenLevels( m, 'KNOR' );
    [strainret_i,strainret_p,strainret_a,strainret_l] = getMgenLevels( m, 'STRAINRET' );
    [arrest_i,arrest_p,arrest_a,arrest_l] = getMgenLevels( m, 'ARREST' );
    [id_sink_i,id_sink_p,id_sink_a,id_sink_l] = getMgenLevels( m, 'ID_SINK' );
    [id_source_i,id_source_p,id_source_a,id_source_l] = getMgenLevels( m, 'ID_SOURCE' );
    [id_edge_i,id_edge_p,id_edge_a,id_edge_l] = getMgenLevels( m, 'ID_EDGE' );
    [id_midvein_i,id_midvein_p,id_midvein_a,id_midvein_l] = getMgenLevels( m, 'ID_MIDVEIN' );
    [id_junction_i,id_junction_p,id_junction_a,id_junction_l] = getMgenLevels( m, 'ID_JUNCTION' );
    [id_rim_i,id_rim_p,id_rim_a,id_rim_l] = getMgenLevels( m, 'ID_RIM' );
    [s_source_i,s_source_p,s_source_a,s_source_l] = getMgenLevels( m, 'S_SOURCE' );
    [s_rim_i,s_rim_p,s_rim_a,s_rim_l] = getMgenLevels( m, 'S_RIM' );
    [s_midvein_i,s_midvein_p,s_midvein_a,s_midvein_l] = getMgenLevels( m, 'S_MIDVEIN' );
    [s_junction_i,s_junction_p,s_junction_a,s_junction_l] = getMgenLevels( m, 'S_JUNCTION' );
    [v_flower_i,v_flower_p,v_flower_a,v_flower_l] = getMgenLevels( m, 'V_FLOWER' );
    [id_spotty_i,id_spotty_p,id_spotty_a,id_spotty_l] = getMgenLevels( m, 'ID_SPOTTY' );
    [id_stripy_i,id_stripy_p,id_stripy_a,id_stripy_l] = getMgenLevels( m, 'ID_STRIPY' );
    [id_late_i,id_late_p,id_late_a,id_late_l] = getMgenLevels( m, 'ID_LATE' );
    [id_sinus_i,id_sinus_p,id_sinus_a,id_sinus_l] = getMgenLevels( m, 'ID_SINUS' );
    [s_sinus_i,s_sinus_p,s_sinus_a,s_sinus_l] = getMgenLevels( m, 'S_SINUS' );
    [s_sink_i,s_sink_p,s_sink_a,s_sink_l] = getMgenLevels( m, 'S_SINK' );
    [id_lip_i,id_lip_p,id_lip_a,id_lip_l] = getMgenLevels( m, 'ID_LIP' );
    [id_lipcliff_i,id_lipcliff_p,id_lipcliff_a,id_lipcliff_l] = getMgenLevels( m, 'ID_LIPCLIFF' );
    [v_speckareal_i,v_speckareal_p,v_speckareal_a,v_speckareal_l] = getMgenLevels( m, 'V_SPECKAREAL' );
    [v_specaniso_i,v_specaniso_p,v_specaniso_a,v_specaniso_l] = getMgenLevels( m, 'V_SPECANISO' );
    [id_early_i,id_early_p,id_early_a,id_early_l] = getMgenLevels( m, 'ID_EARLY' );
    [id_palate_i,id_palate_p,id_palate_a,id_palate_l] = getMgenLevels( m, 'ID_PALATE' );
    [id_hinge_i,id_hinge_p,id_hinge_a,id_hinge_l] = getMgenLevels( m, 'ID_HINGE' );
    [id_ventmidvein_i,id_ventmidvein_p,id_ventmidvein_a,id_ventmidvein_l] = getMgenLevels( m, 'ID_VENTMIDVEIN' );
    [id_latsecvein_i,id_latsecvein_p,id_latsecvein_a,id_latsecvein_l] = getMgenLevels( m, 'ID_LATSECVEIN' );
    [s_ventmidvein_i,s_ventmidvein_p,s_ventmidvein_a,s_ventmidvein_l] = getMgenLevels( m, 'S_VENTMIDVEIN' );
    [s_latsecvein_i,s_latsecvein_p,s_latsecvein_a,s_latsecvein_l] = getMgenLevels( m, 'S_LATSECVEIN' );
    [id_vent_i,id_vent_p,id_vent_a,id_vent_l] = getMgenLevels( m, 'ID_VENT' );
    [s_vent_i,s_vent_p,s_vent_a,s_vent_l] = getMgenLevels( m, 'S_VENT' );
    [id_lat_i,id_lat_p,id_lat_a,id_lat_l] = getMgenLevels( m, 'ID_LAT' );
    [id_latrad_i,id_latrad_p,id_latrad_a,id_latrad_l] = getMgenLevels( m, 'ID_LATRAD' );
    [v_kaniso_i,v_kaniso_p,v_kaniso_a,v_kaniso_l] = getMgenLevels( m, 'V_KANISO' );
    [id_lipbend_i,id_lipbend_p,id_lipbend_a,id_lipbend_l] = getMgenLevels( m, 'ID_LIPBEND' );
    [id_tube_i,id_tube_p,id_tube_a,id_tube_l] = getMgenLevels( m, 'ID_TUBE' );

% Mesh type: rectangle
%            base: 0
%          centre: 0
%          layers: 0
%      randomness: 0.1
%       thickness: 0
%           xdivs: 60
%          xwidth: 0.9
%           ydivs: 20
%          ywidth: 0.3

%            Morphogen    Diffusion   Decay   Dilution   Mutant
%            --------------------------------------------------
%                KAPAR         ----    ----       ----     ----
%                KAPER         ----    ----       ----     ----
%                KBPAR         ----    ----       ----     ----
%                KBPER         ----    ----       ----     ----
%                 KNOR         ----    ----       ----     ----
%            POLARISER         ----    ----       ----     ----
%            STRAINRET         ----    ----       ----     ----
%               ARREST         ----    ----       ----     ----
%              ID_SINK         ----    ----       ----     ----
%            ID_SOURCE         ----    ----       ----     ----
%              ID_EDGE         ----    ----       ----     ----
%           ID_MIDVEIN         ----    ----       ----     ----
%          ID_JUNCTION         ----    ----       ----     ----
%               ID_RIM         ----    ----       ----     ----
%             S_SOURCE         ----    ----       ----     ----
%                S_RIM         ----    ----       ----     ----
%            S_MIDVEIN         ----    ----       ----     ----
%           S_JUNCTION         ----    ----       ----     ----
%             V_FLOWER         ----    ----       ----     ----
%            ID_SPOTTY         ----    ----       ----     ----
%            ID_STRIPY         ----    ----       ----     ----
%              ID_LATE         ----    ----       ----     ----
%             ID_SINUS         ----    ----       ----     ----
%              S_SINUS         ----    ----       ----     ----
%               S_SINK         ----    ----       ----     ----
%               ID_LIP         ----    ----       ----     ----
%          ID_LIPCLIFF         ----    ----       ----     ----
%         V_SPECKAREAL         ----    ----       ----     ----
%          V_SPECANISO         ----    ----       ----     ----
%             ID_EARLY         ----    ----       ----     ----
%            ID_PALATE         ----    ----       ----     ----
%             ID_HINGE         ----    ----       ----     ----
%       ID_VENTMIDVEIN         ----    ----       ----     ----
%        ID_LATSECVEIN         ----    ----       ----     ----
%        S_VENTMIDVEIN         ----    ----       ----     ----
%         S_LATSECVEIN         ----    ----       ----     ----
%              ID_VENT         ----    ----       ----     ----
%               S_VENT         ----    ----       ----     ----
%               ID_LAT         ----    ----       ----     ----
%            ID_LATRAD         ----    ----       ----     ----
%             V_KANISO         ----    ----       ----     ----
%           ID_LIPBEND         ----    ----       ----     ----
%              ID_TUBE         ----    ----       ----     ----


%%% USER CODE: MORPHOGEN INTERACTIONS

% In this section you may modify the mesh in any way that does not
% alter the set of nodes.
% %     
%      if (Steps(m)<14) 
%         id_late_p(:)=zeros (size(id_late_p));
%         id_early_p(:)= ones (size(id_early_p));
%     else
%         id_late_p(:)=ones (size(id_late_p));
%         id_early_p(:)= zeros (size(id_early_p));
%      end
% %     
if (Steps(m)==0) && m.globalDynamicProps.doinit  % Initialisation code.   

    switch modelname
            
        case 'MODEL1' % Testing morphogen gradients that can control growth    
            
            m = leaf_mgen_conductivity( m, 'POLARISER', 0.0001 );  %specifies the diffusion rate of polariser
            m = leaf_mgen_absorption( m, 'POLARISER', 0.01 );     % specifies degradation rate of polariser   
            bottom = m.nodes(:,2) == min(m.nodes(:,2));
            top = m.nodes(:,2)== max(m.nodes(:,2));    
            id_sink_p(top) = 1;
            id_source_p(bottom) = 1;
            P(:) = 0.1;
            P(bottom) = 1;
            P(top) = 0.07;

%     %LIP
%     id_lip_p(:) = 0;
%     id_lip_p(m.nodes(:,2) > 0.2) = 1;
%     %PALATE
%     id_palate_p(:) = 0;
%     id_palate_p(m.nodes(:,2) < 0.2) = 1;
%            
            m = leaf_mgen_edge( m, 'ID_EDGE', 1);
            id_edge_p = m.morphogens(:,id_edge_i);        
            
            id_midvein_p (m.nodes(:,1) < - 0.42 | m.nodes(:,1) > 0.42) = 1;
            
            %S_MIDVEIN
            s_midvein_p(:) = 0;
            s_midvein_p(:) = id_midvein_p(:);
            m = leaf_mgen_conductivity( m, 'S_MIDVEIN', 0.002 );  
            m = leaf_mgen_absorption( m, 'S_MIDVEIN', 0.1 );
            
            %JUNCTION
            id_junction_p (m.nodes(:,1) <0.022 & m.nodes(:,1) > - 0.022) = 1;
            
            %S_JUNCTION
            s_junction_p = id_junction_p;
            m = leaf_mgen_conductivity( m, 'S_JUNCTION', 0.002 );  
            m = leaf_mgen_absorption( m, 'S_JUNCTION', 0.1 );
            
            id_rim_p(m.nodes(:,2) > 0.1) = 1;
            
            %S_RIM
            s_rim_p(:) = 0;
            s_rim_p(:) = id_rim_p;
            m = leaf_mgen_conductivity( m, 'S_RIM', 0.001 );  
            m = leaf_mgen_absorption( m, 'S_RIM', 0.1 );
            
            %S_SOURCE
            s_source_p(:) = 0;
            s_source_p(:) = id_source_p;
            m = leaf_mgen_conductivity( m, 'S_SOURCE', 0.001 );  
            m = leaf_mgen_absorption( m, 'S_SOURCE', 0.1 );
            
        case 'MODEL2' % Testing morphogen gradients that can control growth    
            
            m = leaf_mgen_conductivity( m, 'POLARISER', 0.0001 );  %specifies the diffusion rate of polariser
            m = leaf_mgen_absorption( m, 'POLARISER', 0.01 );     % specifies degradation rate of polariser   
            bottom = m.nodes(:,2) == min(m.nodes(:,2));
            top = m.nodes(:,2)== max(m.nodes(:,2));    
            id_sink_p(top) = 1;
            id_source_p(bottom) = 1;
            P(:) = 0.1;
            P(bottom) = 1;
            P(top) = 0.07;


            %ID_EDGE
            m = leaf_mgen_edge( m, 'ID_EDGE', 1);
            id_edge_p = m.morphogens(:,id_edge_i);        
            
            id_midvein_p (m.nodes(:,1) < - 0.42 | m.nodes(:,1) > 0.42) = 1;
            
            %S_MIDVEIN
            s_midvein_p(:) = 0;
            s_midvein_p(:) = id_midvein_p(:);
            m = leaf_mgen_conductivity( m, 'S_MIDVEIN', 0.002 );  
            m = leaf_mgen_absorption( m, 'S_MIDVEIN', 0.1 );
            
            %JUNCTION
            id_junction_p (m.nodes(:,1) <0.022 & m.nodes(:,1) > - 0.022) = 1; 
            
            %S_JUNCTION
            s_junction_p = id_junction_p;
            m = leaf_mgen_conductivity( m, 'S_JUNCTION', 0.002 );  
            m = leaf_mgen_absorption( m, 'S_JUNCTION', 0.1 );
            
            id_rim_p (:) = 0;
            id_rim_p(m.nodes(:,2) < 0.02 & m.nodes(:,2) > - 0.02) = 1;
            
            %PALATE
            id_palate_p (:) = 0;
            id_palate_p(m.nodes(:,2) < - 0.02) = 1;
            
            %S_RIM
            s_rim_p(:) = 0;
            s_rim_p(:) = id_rim_p .* inh (100, id_lipcliff_p);
            m = leaf_mgen_conductivity( m, 'S_RIM', 0.0005 );  
            m = leaf_mgen_absorption( m, 'S_RIM', 0.1 );
            
            %S_SOURCE
            s_source_p(:) = 0;
            s_source_p(:) = id_source_p;
            m = leaf_mgen_conductivity( m, 'S_SOURCE', 0.0001 );  
            m = leaf_mgen_absorption( m, 'S_SOURCE', 0.1 );
            
            %S_SINK
            s_sink_p(:) = 0;
            s_sink_p(:) = id_sink_p;
            m = leaf_mgen_conductivity( m, 'S_SINK', 0.0001 );  
            m = leaf_mgen_absorption( m, 'S_SINK', 0.1 );
            
            id_lip_p (:) = 0;
            id_lip_p(m.nodes(:,2)  > 0.085) = 1;
            
            id_lipcliff_p (:) = 0;
            id_lipcliff_p (m.nodes(:,2) < 0.085 & m.nodes(:,2) > -0.01) = 1;
            
            
     case 'MODEL3' % Testing morphogen gradients that can control growth    
            
            m = leaf_mgen_conductivity( m, 'POLARISER', 0.001 );  %specifies the diffusion rate of polariser
            m = leaf_mgen_absorption( m, 'POLARISER', 0.01 );     % specifies degradation rate of polariser   
            bottom = m.nodes(:,2) == min(m.nodes(:,2));
            top = m.nodes(:,2)== max(m.nodes(:,2));    
            id_sink_p(top) = 1;
            id_source_p(bottom) = 1;
            P(:) = 0.1;
            P(bottom) = 1;
            P(top) = 0.07;

            %ID_EDGE
            m = leaf_mgen_edge( m, 'ID_EDGE', 1);
            id_edge_p = m.morphogens(:,id_edge_i);        
            
            id_midvein_p (m.nodes(:,1) < - 0.42 | m.nodes(:,1) > 0.42) = 1;
            
            %S_MIDVEIN
            s_midvein_p(:) = 0;
            s_midvein_p(:) = id_midvein_p(:);
            m = leaf_mgen_conductivity( m, 'S_MIDVEIN', 0.002 );  
            m = leaf_mgen_absorption( m, 'S_MIDVEIN', 0.1 );
            
            %JUNCTION
            id_junction_p (m.nodes(:,1) <0.022 & m.nodes(:,1) > - 0.022) = 1; 
            
            %S_JUNCTION
            s_junction_p = id_junction_p;
            m = leaf_mgen_conductivity( m, 'S_JUNCTION', 0.002 );  
            m = leaf_mgen_absorption( m, 'S_JUNCTION', 0.1 );
            
            id_rim_p (:) = 0;
            id_rim_p(m.nodes(:,2) < 0.02 & m.nodes(:,2) > - 0.02) = 1;
            
            id_lip_p (:) = 0;
            id_lip_p(m.nodes(:,2)  > 0.085) = 1;
            
            id_lipcliff_p (:) = 0;
            id_lipcliff_p (m.nodes(:,2) < 0.085 & m.nodes(:,2) > -0.01) = 1;
            
            %PALATE
            id_palate_p (:) = 0;
            id_palate_p(m.nodes(:,2) < - 0.02) = 1;
            
            %S_RIM
            s_rim_p(:) = 0;
            s_rim_p(:) = id_rim_p .* inh (100, id_lipcliff_p);
            m = leaf_mgen_conductivity( m, 'S_RIM', 0.0005 );  
            m = leaf_mgen_absorption( m, 'S_RIM', 0.1 );
            
            %S_SOURCE
            s_source_p(:) = 0;
            s_source_p(:) = id_source_p;
            m = leaf_mgen_conductivity( m, 'S_SOURCE', 0.0001 );  
            m = leaf_mgen_absorption( m, 'S_SOURCE', 0.1 );
            
            %S_SINK
            s_sink_p(:) = 0;
            s_sink_p(:) = id_sink_p;
            m = leaf_mgen_conductivity( m, 'S_SINK', 0.0001 );  
            m = leaf_mgen_absorption( m, 'S_SINK', 0.1 );
            
         case {'MODEL4','MODEL4a', 'MODEL5', 'MODEL6','MODEL6_div', 'MODEL7'} % MODEL4 - MIRROR PALATE and LIP    
            
            m = leaf_mgen_conductivity( m, 'POLARISER', 0.001 );  %specifies the diffusion rate of polariser
            m = leaf_mgen_absorption( m, 'POLARISER', 0.01 );     % specifies degradation rate of polariser   
            bottom = m.nodes(:,2) == min(m.nodes(:,2));
            top = m.nodes(:,2)== max(m.nodes(:,2));    
            id_sink_p(top) = 1;
            id_source_p(bottom) = 1;
            P(:) = 0.1;
            P(bottom) = 1;
            P(top) = 0.07;
            m.morphogenclamp(bottom, polariser_i) = 1;
            m.morphogenclamp(top, polariser_i) = 1;
            
            %LP+VP+LP width = 270+350+270 = 900um
            %PALATE+RIM+LIP length = 300 um
            %VP = (m.nodes(:,1) <0.175 & m.nodes(:,1) > - 0.175) midvein at 0
            %LP1 = (m.nodes(:,1) > 0.175) - midvein at around 0.4 and hinge more than 0.4
            %LP2 = (m.nodes(:,1) < -0.175)


            %ID_EDGE
            m = leaf_mgen_edge( m, 'ID_EDGE', 1);
            id_edge_p = m.morphogens(:,id_edge_i);        
            
            %ID_HINGE
            id_hinge_p (m.nodes(:,1) < - 0.43 | m.nodes(:,1) > 0.43) = 1;
            
            %ID_VENT
            id_vent_p (m.nodes(:,1) > - 0.175 & m.nodes(:,1) < 0.175) = 1;
            
            %S_VENT
            s_vent_p(:) = 0;
            s_vent_p(:) = id_vent_p(:);
            m = leaf_mgen_conductivity( m, 'S_VENT', 0.01 );  
            m = leaf_mgen_absorption( m, 'S_VENT', 0.1 );
            
            %ID_LAT
            id_lat_p (m.nodes(:,1) < - 0.175 | m.nodes(:,1) > 0.175) = 1;
            
            %ID_LATRAD
            id_latrad_p (m.nodes(:,1) < - 0.315 | m.nodes(:,1) > 0.321) = 1;
                        
            %JUNCTION
            id_junction_p((m.nodes(:,1) < 0.181 & m.nodes(:,1) > 0.15)) = 1;
            id_junction_p((m.nodes(:,1) > - 0.179 & m.nodes(:,1) < - 0.150) ) = 1;
            
            %S_JUNCTION
            s_junction_p = id_junction_p;
            m = leaf_mgen_conductivity( m, 'S_JUNCTION', 0.001 );  
            m = leaf_mgen_absorption( m, 'S_JUNCTION', 0.01 );
            
            %ID_MIDVEIN
            id_midvein_p (m.nodes(:,1) > 0.311 & m.nodes(:,1) < 0.331) = 1;
            id_midvein_p (m.nodes(:,1) < - 0.311 & m.nodes(:,1) > - 0.331) = 1;
            
            %S_MIDVEIN
            s_midvein_p(:) = 0;
            s_midvein_p(:) = id_midvein_p(:);
            m = leaf_mgen_conductivity( m, 'S_MIDVEIN', 0.002 );  
            m = leaf_mgen_absorption( m, 'S_MIDVEIN', 0.02 );
            
            %ID_VENTMIDVEIN
            id_ventmidvein_p (m.nodes(:,1) > - 0.0118 & m.nodes(:,1) < 0.02) = 1;
            
            %S_VENTMIDVEIN
            s_ventmidvein_p(:) = 0;
            s_ventmidvein_p(:) = id_ventmidvein_p(:);
            m = leaf_mgen_conductivity( m, 'S_VENTMIDVEIN', 0.002 );  
            m = leaf_mgen_absorption( m, 'S_VENTMIDVEIN', 0.02 );
            
            %ID_LATSECVEIN (maybe change specifications to be dependent on
            %a window of s_vent)
            id_latsecvein_p (m.nodes(:,1) > 0.231 & m.nodes(:,1) < 0.251) = 1;
            id_latsecvein_p (m.nodes(:,1) < - 0.231 & m.nodes(:,1) > - 0.251) = 1;
            
            %S_LATSECVEIN
            s_latsecvein_p(:) = 0;
            s_latsecvein_p(:) = id_latsecvein_p(:);
            m = leaf_mgen_conductivity( m, 'S_LATSECVEIN', 0.001 );  
            m = leaf_mgen_absorption( m, 'S_LATSECVEIN', 0.01 );
            
            %ID_RIM
            id_rim_p (:) = 0;
            id_rim_p(m.nodes(:,2) < 0.02 & m.nodes(:,2) > - 0.02) = 1;
            
            %S_RIM
            s_rim_p(:) = 0;
            s_rim_p(:) = id_rim_p .* inh (100, id_lipcliff_p);
            m = leaf_mgen_conductivity( m, 'S_RIM', 0.0005 );  
            m = leaf_mgen_absorption( m, 'S_RIM', 0.1 );
            
            %ID_LIP
            id_lip_p (:) = 0;
            id_lip_p(m.nodes(:,2)  > 0.1) = 1;
            
            %ID_LIP
            id_lipbend_p (:) = 0;
            id_lipbend_p(m.nodes(:,2) > 0.080 & m.nodes(:,2)< 0.1) = 1;
            
            %ID_LIPCLIFF
            id_lipcliff_p (:) = 0;
            id_lipcliff_p (m.nodes(:,2) < 0.080 & m.nodes(:,2) > 0.021) = 1;
            
            %PALATE
            id_palate_p (:) = 0;
            id_palate_p (m.nodes(:,2) < - 0.02 & m.nodes (:,2) > -0.12) = 1;
            
             %TUBE
            id_tube_p (:) = 0;
            id_tube_p(m.nodes(:,2) < - 0.12) = 1;
            
            %S_SOURCE
            s_source_p(:) = 0;
            s_source_p(:) = id_source_p;
            m = leaf_mgen_conductivity( m, 'S_SOURCE', 0.0002 );  
            m = leaf_mgen_absorption( m, 'S_SOURCE', 0.1 );
            
            %S_SINK
            s_sink_p(:) = 0;
            s_sink_p(:) = id_sink_p;
            m = leaf_mgen_conductivity( m, 'S_SINK', 0.0002 );  
            m = leaf_mgen_absorption( m, 'S_SINK', 0.1 );
    end
    
end

if(Steps(m)==5)        
    m = leaf_mgen_conductivity( m, 'POLARISER', 0 );  %specifies the diffusion rate of polariser
    m = leaf_mgen_absorption( m, 'POLARISER', 0 );
    m = leaf_mgen_conductivity( m, 'S_MIDVEIN', 0 );  
    m = leaf_mgen_absorption( m, 'S_MIDVEIN', 0 );
    m = leaf_mgen_conductivity( m, 'S_SOURCE', 0 );  
    m = leaf_mgen_absorption( m, 'S_SOURCE', 0 );
    m = leaf_mgen_conductivity( m, 'S_JUNCTION', 0 );  
    m = leaf_mgen_absorption( m, 'S_JUNCTION', 0 );
    m = leaf_mgen_conductivity( m, 'S_RIM', 0 );  
    m = leaf_mgen_absorption( m, 'S_RIM', 0 );
    m = leaf_mgen_conductivity( m, 'S_SINK', 0 );  
    m = leaf_mgen_absorption( m, 'S_SINK', 0 );
    m = leaf_mgen_conductivity( m, 'S_LATSECVEIN', 0 );  
    m = leaf_mgen_absorption( m, 'S_LATSECVEIN', 0 );
    m = leaf_mgen_conductivity( m, 'S_VENT', 0 );  
    m = leaf_mgen_absorption( m, 'S_VENT', 0 );
    m = leaf_mgen_conductivity( m, 'S_VENTMIDVEIN', 0 );  
    m = leaf_mgen_absorption( m, 'S_VENTMIDVEIN', 0 );
     
   
    id_lipcliff_p (:) = 0;
    id_lipcliff_p (m.nodes(:,2) < 0.085 & m.nodes(:,2) > 0.01) = 1;
    
     %add clones

    m = leaf_makesecondlayer( m, ...  % This function adds biological cells.
            'mode', 'each', ...  % Make biological cells randomly scattered over the flower.
            'relarea', 1/2700, ...   % Each cell has area was 1/16000 of the initial area of the flower.
            'probpervx', 'V_FLOWER', ... % induce transposed cells over whole corolla
            'numcells',400,...%number of cells (that will become clones)
            'sides', 15, ...  % Each cell is approximated as a 6-sided regular polygon.
            'colors', [0.5 0.5 0.5], ...  % Default colour is gray but
            'colorvariation',1,... % Each cell is a random colour
            'add', true );  % These cells are added to any cells existing alread
        m = leaf_plotoptions( m, 'cellbodyvalue', '' );   
  
end

if(Steps(m)==6) 
    
     switch modelname
            
        case 'MODEL1'
    
        %SPOTTY
        id_spotty_p(:) = 0;
        id_spotty_p = pro (10, s_rim_p).* inh (10, s_junction_p) .* inh (10, s_midvein_p);

        %STRIPY
        id_stripy_p(:) = 0;
        id_stripy_p =4.3* pro (20, s_junction_p .* s_rim_p) .* inh (7, s_rim_p.* inh (5, s_junction_p)).* inh (40, s_midvein_p).* inh (30, s_source_p); 

        case 'MODEL2'
    
        %SPOTTY
        id_spotty_p(:) = 0;
        id_spotty_p = pro (10, s_rim_p).* inh (10, s_junction_p) .* inh (10, s_midvein_p);

        %STRIPY
        id_stripy_p(:) = 0;
        id_stripy_p =  1.2*pro (0, s_junction_p) .* inh (3, s_rim_p.* inh (5, s_junction_p)).* inh (8, s_midvein_p).* inh (1.5, s_source_p).* inh (0, id_lip_p); 
        
        case 'MODEL3'
    
        %SPOTTY
        id_spotty_p(:) = 0;
        id_spotty_p = pro (10, s_rim_p).* inh (10, s_junction_p) .* inh (10, s_midvein_p);

        %STRIPY
        id_stripy_p(:) = 0;
        id_stripy_p =  2*pro (0, s_junction_p) .* inh (3, s_rim_p.* inh (5, s_junction_p)).* inh (8, s_midvein_p).* inh (1.5, s_source_p).* inh (0, id_lip_p); 
        
        case {'MODEL4', 'MODEL4a'}
    
        %SPOTTY
        id_spotty_p(:) = 0;
        id_spotty_p = pro (10, s_rim_p).* pro (15, s_latsecvein_p) .* inh (5, s_midvein_p);

        %STRIPY
        id_stripy_p(:) = 0;
        id_stripy_p =  3*pro (5, s_ventmidvein_p).* inh (2, s_rim_p); 
        
        
        case 'MODEL5'
    
        %SPOTTY
        id_spotty_p(:) = 0;
        id_spotty_p = pro (10, s_rim_p).* pro (15, s_latsecvein_p) .* inh (5, s_midvein_p);

        %STRIPY
        id_stripy_p(:) = 0;
        id_stripy_p =  3*pro (5, s_ventmidvein_p).* inh (2, s_rim_p);
        
         case {'MODEL6', 'MODEL6_div', 'MODEL7'}
    
        %SPOTTY
        id_spotty_p(:) = 0;
        id_spotty_p = pro (10, s_rim_p).* pro (15, s_latsecvein_p) .* inh (5, s_midvein_p);

        %STRIPY
        id_stripy_p(:) = 0;
        id_stripy_p =  3*pro (5, s_ventmidvein_p).* inh (1, s_rim_p);
     end
end

% if(Steps(m)==17)
%    id_early_p(:) = 0;
% end

if (Steps(m)>6)
    % Code for specific models.    
    switch modelname
        case 'MODEL1'  % @@model MODEL1
            
            kapar_p(:) = 0.075*id_stripy_p.* inh (0.5, id_junction_p .* inh (100, s_source_p)); % @@ Eqn xx
            kaper_p(:) = 0.075*id_spotty_p .* inh (3, (s_junction_p > 0.06) .* s_rim_p).* inh (1, s_midvein_p > 0.05) .* inh (5, s_midvein_p) .* pro(30, s_source_p);      % .* inh (20, id_rim_p.*id_junction_p)@@ Eqn xx
            kbpar_p(:) = kapar_p;
            kbper_p(:) = kaper_p;  % @@ Eqn xx
            knor_p(:)  = 0.044;  % @@ Eqn xx
            
       case 'MODEL2'  % @@model MODEL1
            
            kbpar_p(:) = 0.075*id_stripy_p .* pro (2, id_rim_p .* inh (10, id_lipcliff_p)) + (0.1*id_lipcliff_p .* (id_spotty_p > 1.07)); % @@ Eqn xx
            kbper_p(:) = 0.075*id_spotty_p .* inh (3, (s_junction_p > 0.06) .* s_rim_p).* inh (1, s_midvein_p > 0.05) .* inh (5, s_midvein_p).* pro (0, id_rim_p) .* pro(5, s_source_p);      % .* inh (20, id_rim_p.*id_junction_p)@@ Eqn xx
            kapar_p(:) = kbpar_p...
                .* inh (10, id_rim_p.* inh (10, id_lipcliff_p));
            kaper_p(:) = kbper_p...
                .* inh (0, id_rim_p);  % @@ Eqn xx
            knor_p(:)  = 0.044;  % @@ Eqn xx
            v_speckareal_p = (kapar_p +kaper_p +kbpar_p +kbper_p)./2;
            v_specaniso_p = kapar_p - kaper_p;
            
            if (Steps(m)>14)
                
            kbpar_p(:) = 0.075*id_stripy_p .* pro (4, id_palate_p .* inh (20, s_source_p)).* inh (10, s_midvein_p) + ( 0.1*id_lipcliff_p .* (id_spotty_p > 1.07)); % @@ Eqn xx
            kbper_p(:) = 0.08*id_spotty_p .* inh (1.5, (s_junction_p > 0.06) .* s_rim_p).* inh (1, s_midvein_p > 0.05) .* inh (5, s_midvein_p).* pro (0, id_rim_p) .* pro(5, s_source_p) + (0.045* id_stripy_p .* id_lip_p);      % .* inh (20, id_rim_p.*id_junction_p)@@ Eqn xx
            kapar_p(:) = kbpar_p...
                .* inh (0, id_rim_p);
            kaper_p(:) = kbper_p...
                .* inh (0, id_rim_p);  % @@ Eqn xx
            knor_p(:)  = 0.044;  % @@ Eqn xx
            v_speckareal_p = (kapar_p +kaper_p +kbpar_p +kbper_p)./2;
            v_specaniso_p = kapar_p - kaper_p;
            end
            
      case 'MODEL3' %Adjusting the growth rates to the system use for the Antirrhinum model
            
            kbpar_p(:) = 0.075...
                .* pro (0.3, id_stripy_p)...
                .* pro (0.4, id_rim_p .* inh (10, id_lipcliff_p).* inh (5, s_midvein_p))...
                .* pro (0.2, id_lipcliff_p .* (id_spotty_p > 1.07)); % @@ Eqn xx
            kbper_p(:) = 0.06...
                .* pro (0.8, id_spotty_p .* inh (1, (s_junction_p > 0.06) .* s_rim_p))... ...
                .* inh (1.5, id_spotty_p .* s_midvein_p) ...
                .* pro (2.5, id_spotty_p .* s_source_p);      
            kapar_p(:) = kbpar_p...
                .* inh (10, id_rim_p.* inh (10, id_lipcliff_p).* inh (20, s_midvein_p));
            kaper_p(:) = kbper_p...
                .* inh (0, id_rim_p);  % @@ Eqn xx
            knor_p(:)  = 0.044;  % @@ Eqn xx
            v_speckareal_p = (kapar_p +kaper_p +kbpar_p +kbper_p)./2;
            v_specaniso_p = kapar_p - kaper_p;
            
            if (Steps(m)>14)
                
            kbpar_p(:) = 0.075...
                .* pro (0.7, id_stripy_p .* id_palate_p .* inh (10, s_source_p))...
                .* pro (0.7, id_lipcliff_p .* (id_spotty_p > 1.07) .* inh (10, s_midvein_p));
            kbper_p(:) = 0.06...
                .* pro (0.7, id_spotty_p .* inh (2, s_rim_p .* (s_junction_p > 0.06)))...
                .* inh (1, id_spotty_p .* s_midvein_p)...
                .* pro (2, id_spotty_p .* s_source_p)...
                .* pro (0.2, id_lip_p);      % .* inh (20, id_rim_p.*id_junction_p)@@ Eqn xx
            kapar_p(:) = kbpar_p...
                .* inh (0, id_rim_p);
            kaper_p(:) = kbper_p...
                .* inh (0, id_rim_p);  % @@ Eqn xx
            knor_p(:)  = 0.044;  % @@ Eqn xx
            v_speckareal_p = (kapar_p +kaper_p +kbpar_p +kbper_p)./2;
            v_specaniso_p = kapar_p - kaper_p;
            end
            
      case 'MODEL4' %Adjusting the growth rates to the system use for the Antirrhinum model
            
            kbpar_p(:) = 0.1 .* pro(1, id_rim_p .* inh (0.5, s_midvein_p > 0.09));
            kbper_p(:) = 0.1;      
            kapar_p(:) = kbpar_p...
                 .* inh (5, id_rim_p.* inh (10, s_midvein_p));
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.044;  % @@ Eqn xx
            v_speckareal_p = (kapar_p +kaper_p +kbpar_p +kbper_p)./2;
            v_specaniso_p = kapar_p - kaper_p;
            
            if (Steps(m)>14)
            
            kbpar_p(:) = 0.1 .* pro(1.7, id_stripy_p .* s_vent_p.* inh (0.1, id_ventmidvein_p).* pro (4, s_junction_p)).* inh (0, s_midvein_p).* inh (0, s_midvein_p>0.09).* inh (2, s_sink_p).* inh (2, s_source_p ).* inh (0, id_rim_p); % @@ Eqn xx
            kbper_p(:) = 0.1 .* pro(1, id_spotty_p .* pro(0,s_junction_p>0.09).*inh(0, s_source_p).*inh(0, s_sink_p)).* inh (0.5, s_midvein_p>0.09) .* inh (10, s_ventmidvein_p) .* inh (5, s_midvein_p).* inh (0.5, id_vent_p) + 0.5*s_source_p .* pro (1, id_latrad_p)+ 0.5*s_sink_p .* pro (1, id_latrad_p);
            kapar_p(:) = kbpar_p...
                .* inh (0, id_rim_p.* inh (10, s_midvein_p));
            kaper_p(:) = kbper_p;  % @@ Eqn xx
            knor_p(:)  = 0.044;  % @@ Eqn xx
            v_speckareal_p = (kapar_p +kaper_p +kbpar_p +kbper_p)./2;
            v_specaniso_p = kapar_p - kaper_p;
            v_kaniso_p =  kapar_p./(kapar_p + kaper_p);
            end
            
            
          case 'MODEL4a' %Adjusting the growth rates to the system use for the Antirrhinum model
            
            kbpar_p(:) = 0.1 .* pro(1, id_rim_p .* inh (0.5, s_midvein_p > 0.09));
            kbper_p(:) = 0.1;      
            kapar_p(:) = kbpar_p...
                 .* inh (0, id_rim_p.* inh (10, s_midvein_p));
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.044;  % @@ Eqn xx
            v_speckareal_p = (kapar_p +kaper_p +kbpar_p +kbper_p)./2;
            v_specaniso_p = kapar_p - kaper_p;
            
            if (Steps(m)>14)
            
            kbpar_p(:) = 0.1 .* pro(1.7, id_stripy_p .* s_vent_p.* inh (0.1, id_ventmidvein_p).* pro (4, s_junction_p)).* inh (0, s_midvein_p).* inh (0, s_midvein_p>0.09).* inh (2, s_sink_p).* inh (2, s_source_p ).* inh (0, id_rim_p); % @@ Eqn xx
            kbper_p(:) = 0.1 .* pro(1, id_spotty_p .* pro(0,s_junction_p>0.09).*inh(0, s_source_p).*inh(0, s_sink_p)).* inh (0.5, s_midvein_p>0.09) .* inh (10, s_ventmidvein_p) .* inh (5, s_midvein_p).* inh (0.5, id_vent_p) + 0.5*s_source_p .* pro (1, id_latrad_p)+ 0.5*s_sink_p .* pro (1, id_latrad_p);
            kapar_p(:) = kbpar_p...
                .* inh (0, id_rim_p.* inh (10, s_midvein_p));
            kaper_p(:) = kbper_p;  % @@ Eqn xx
            knor_p(:)  = 0.044;  % @@ Eqn xx
            v_speckareal_p = (kapar_p +kaper_p +kbpar_p +kbper_p)./2;
            v_specaniso_p = kapar_p - kaper_p;
            v_kaniso_p =  kapar_p./(kapar_p + kaper_p);
            end
            
        case 'MODEL5' %Adjusting the growth rates to the system use for the Antirrhinum model
            
            kbpar_p(:) = 0.1 .* pro(1, id_rim_p .* inh (0.5, s_midvein_p > 0.09));
            kbper_p(:) = 0.1;      
            kapar_p(:) = kbpar_p...
                 .* inh (5, id_rim_p.* inh (10, s_midvein_p));
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.044;  % @@ Eqn xx
            v_speckareal_p = (kapar_p +kaper_p +kbpar_p +kbper_p)./2;
            v_specaniso_p = kapar_p - kaper_p;
            
            if (Steps(m)>14)
            
            kbpar_p(:) = 0.1 ...
                .* pro (0.8, id_stripy_p .*  id_palate_p .* inh (0.3, id_ventmidvein_p).* pro (2, s_junction_p))...
                .* pro (0.5, id_stripy_p .* id_lip_p)...
                .* pro (0.7, id_stripy_p .* id_lipcliff_p .*inh(0, s_midvein_p))...
                .* inh (0.5, id_lipbend_p)...
                .* inh (2, s_sink_p)...
                .* inh (2, s_source_p ) + (0*id_lipcliff_p); % @@ Eqn xx
            kbper_p(:) = 0.1 ...
                .* pro (1, id_spotty_p .* pro (0.4, id_lipcliff_p).* inh (2, (s_junction_p > 0.124) .* s_rim_p))...
                .* inh (1, id_lipbend_p)...
                .* inh (0.5, s_midvein_p>0.09) ...
                .* inh (10, s_ventmidvein_p) ...
                .* inh (5, s_midvein_p)...
                .* inh (0.5, id_vent_p) + 0.05* id_lip_p + s_source_p .* pro (1, id_latrad_p)+ 0.5*s_sink_p .* pro (1, id_latrad_p);
            kapar_p(:) = kbpar_p
            kaper_p(:) = kbper_p;  % @@ Eqn xx
            knor_p(:)  = 0.044;  % @@ Eqn xx
            v_speckareal_p = (kapar_p +kaper_p +kbpar_p +kbper_p)./2;
            v_specaniso_p = kapar_p - kaper_p;
            v_kaniso_p =  kapar_p./(kapar_p + kaper_p);

            end
            
       case 'MODEL6' %Adjusting the growth rates to the system use for the Antirrhinum model
            
            kbpar_p(:) = 0.1 .* pro(1, id_rim_p .* inh (0.5, s_midvein_p > 0.09));
            kbper_p(:) = 0.1;      
            kapar_p(:) = kbpar_p...
                 .* inh (5, id_rim_p.* inh (10, s_midvein_p));
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.044;  % @@ Eqn xx
            v_speckareal_p = (kapar_p +kaper_p +kbpar_p +kbper_p)./2;
            v_specaniso_p = kapar_p - kaper_p;
            
            if (Steps(m)>14)
            
          kbpar_p(:) = 0.1 ...
                .* pro (0.6, id_stripy_p .*  id_palate_p .* inh (0.3, id_ventmidvein_p).* pro (4, s_junction_p))...
                .* pro (0.5, id_stripy_p .* id_lip_p)...
                .* pro (0.5, id_stripy_p .* id_lipcliff_p .* pro (0.7, s_latsecvein_p > 0.074 .* inh (3, s_rim_p).* inh (3, s_sink_p)).*inh(0, s_midvein_p))...
                .* inh (0.5, id_lipbend_p)...
                .* inh (0.5, s_midvein_p>0.09)...
                .* inh (1, id_rim_p)...
                .* inh (0, s_sink_p)...
                .* inh (0, s_source_p ) + (0*id_lipcliff_p); % @@ Eqn xx
          kbper_p(:) = 0.1 ...
                .* pro (0.4, id_spotty_p .* pro (1.5, id_lipcliff_p) .* pro (0.2, id_rim_p).* inh (2, (s_junction_p > 0.120) .* s_rim_p).* pro (0.5, s_latsecvein_p > 0.06))...
                .* inh (2, id_lipbend_p)...
                .* inh (0.5, s_midvein_p>0.09) ...
                .* pro (0.7, id_lipcliff_p .* id_vent_p .* inh (1, s_ventmidvein_p).* inh (2, id_junction_p) .*inh (5, s_rim_p))... 
                .* inh (5, s_ventmidvein_p) ...
                .* inh (0, s_midvein_p)...
                .* inh (0.5, id_vent_p) + 0.1* id_lip_p + s_source_p .* pro (1, id_latrad_p);
         kapar_p(:) = kbpar_p...
                .* pro (0.2, id_lip_p.* inh (2, id_vent_p));
         kaper_p(:) = kbper_p;  % @@ Eqn xx
         knor_p(:)  = 0.044;  % @@ Eqn xx
         v_speckareal_p = (kapar_p +kaper_p +kbpar_p +kbper_p)./2;
         v_specaniso_p = kapar_p - kaper_p;
         v_kaniso_p =  kapar_p./(kapar_p + kaper_p);


            end
            
        case 'MODEL6_div' %Adjusting the growth rates to the system use for the Antirrhinum model
            
            % starting point is to create a vulcano region arouhnd the foci
            
            kbpar_p(:) = 0.1 .* pro(1, id_rim_p .* inh (0.5, s_midvein_p > 0.09));
            kbper_p(:) = 0.1;      
            kapar_p(:) = kbpar_p...
                 .* inh (5, id_rim_p.* inh (10, s_midvein_p));
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.044;  % @@ Eqn xx
            v_speckareal_p = (kapar_p +kaper_p +kbpar_p +kbper_p)./2;
            v_specaniso_p = kapar_p - kaper_p;
            
            if (Steps(m)>14)
            
          kbpar_p(:) = 0.1 ...
                .* pro (0.1, id_stripy_p .*  id_palate_p .* inh (0.3, id_ventmidvein_p).* pro (4, s_junction_p))...
                .* pro (0.5, id_stripy_p .* id_lip_p)...
                .* pro (0.5, id_stripy_p .* id_lipcliff_p .*inh(0, s_midvein_p))...
                .* inh (0.5, id_lipbend_p)...
                .* inh (0.5, s_midvein_p>0.09)...
                .* inh (0, s_sink_p)...
                .* inh (0, s_source_p ) + (0*id_lipcliff_p); % @@ Eqn xx
          kbper_p(:) = 0.1 ...
                .* pro (0.1, id_spotty_p .* pro (1.5, id_lipcliff_p) .* pro (0.2, id_rim_p).* inh (2, (s_junction_p > 0.120) .* s_rim_p))...
                .* inh (1, id_lipbend_p)...
                .* inh (0.5, s_midvein_p>0.09) ...
                .* inh (5, s_ventmidvein_p) ...
                .* inh (0, s_midvein_p)...
                .* inh (0.5, id_vent_p) + 0.1* id_lip_p + s_source_p .* pro (1, id_latrad_p);
         kapar_p(:) = kbpar_p...
                .* pro (0.2, id_lip_p.* inh (2, id_vent_p));
         kaper_p(:) = kbper_p;  % @@ Eqn xx
         knor_p(:)  = 0.044;  % @@ Eqn xx
         v_speckareal_p = (kapar_p +kaper_p +kbpar_p +kbper_p)./2;
         v_specaniso_p = kapar_p - kaper_p;
         v_kaniso_p =  kapar_p./(kapar_p + kaper_p);


            end
            
         case 'MODEL7' %Adjusting the growth rates to the system use for the Antirrhinum model
            
            kbpar_p(:) = 0.1 .* pro(1, id_rim_p .* inh (0.5, s_midvein_p > 0.09));
            kbper_p(:) = 0.1;      
            kapar_p(:) = kbpar_p...
                 .* inh (5, id_rim_p.* inh (10, s_midvein_p));
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.044;  % @@ Eqn xx
            v_speckareal_p = (kapar_p +kaper_p +kbpar_p +kbper_p)./2;
            v_specaniso_p = kapar_p - kaper_p;
            
            if (Steps(m)>14)
            
          kbpar_p(:) = 0.1 ...
                .* pro (0.6, id_stripy_p .*  id_palate_p .* inh (0.3, id_ventmidvein_p).* pro (4, s_junction_p))...
                .* pro (0.5, id_stripy_p .* id_lip_p)...
                .* pro (0.5, id_stripy_p .* id_lipcliff_p .*inh(0, s_midvein_p))...
                .* inh (0.5, id_lipbend_p)...
                .* inh (0.5, s_midvein_p>0.09)...
                .* inh (1, id_rim_p)...
                .* inh (0, s_sink_p)...
                .* inh (0, s_source_p ) + (0*id_lipcliff_p); % @@ Eqn xx
          kbper_p(:) = 0.1 ...
                .* pro (0.4, id_spotty_p .* pro (1.5, id_lipcliff_p) .* pro (0.2, id_rim_p).* inh (2, (s_junction_p > 0.120) .* s_rim_p))...
                .* inh (1.5, id_lipbend_p)...
                .* inh (0.5, s_midvein_p>0.09) ...
                .* pro (0.7, id_lipcliff_p .* id_vent_p .* inh (1, s_ventmidvein_p).* inh (2, id_junction_p) .*inh (5, s_rim_p))...
                .* inh (5, s_ventmidvein_p) ...
                .* inh (0, s_midvein_p)...
                .* inh (0.5, id_vent_p) + 0.05* id_lip_p + s_source_p .* pro (1, id_latrad_p);
         kapar_p(:) = kbpar_p...
                .* pro (0.2, id_lip_p.* inh (2, id_vent_p));
         kaper_p(:) = kbper_p;  % @@ Eqn xx
         knor_p(:)  = 0.044;  % @@ Eqn xx
         v_speckareal_p = (kapar_p +kaper_p +kbpar_p +kbper_p)./2;
         v_specaniso_p = kapar_p - kaper_p;
         v_kaniso_p =  kapar_p./(kapar_p + kaper_p);


            end

     % end
 
       otherwise
            % If this happens, maybe you forgot a model.
    end
end
%%% END OF USER CODE: MORPHOGEN INTERACTIONS

%%% SECTION 3: INSTALLING MODIFIED VALUES BACK INTO MESH STRUCTURE
%%% AUTOMATICALLY GENERATED CODE: DO NOT EDIT.
    m.morphogens(:,polariser_i) = P;
    m.morphogens(:,kapar_i) = kapar_p;
    m.morphogens(:,kaper_i) = kaper_p;
    m.morphogens(:,kbpar_i) = kbpar_p;
    m.morphogens(:,kbper_i) = kbper_p;
    m.morphogens(:,knor_i) = knor_p;
    m.morphogens(:,strainret_i) = strainret_p;
    m.morphogens(:,arrest_i) = arrest_p;
    m.morphogens(:,id_sink_i) = id_sink_p;
    m.morphogens(:,id_source_i) = id_source_p;
    m.morphogens(:,id_edge_i) = id_edge_p;
    m.morphogens(:,id_midvein_i) = id_midvein_p;
    m.morphogens(:,id_junction_i) = id_junction_p;
    m.morphogens(:,id_rim_i) = id_rim_p;
    m.morphogens(:,s_source_i) = s_source_p;
    m.morphogens(:,s_rim_i) = s_rim_p;
    m.morphogens(:,s_midvein_i) = s_midvein_p;
    m.morphogens(:,s_junction_i) = s_junction_p;
    m.morphogens(:,v_flower_i) = v_flower_p;
    m.morphogens(:,id_spotty_i) = id_spotty_p;
    m.morphogens(:,id_stripy_i) = id_stripy_p;
    m.morphogens(:,id_late_i) = id_late_p;
    m.morphogens(:,id_sinus_i) = id_sinus_p;
    m.morphogens(:,s_sinus_i) = s_sinus_p;
    m.morphogens(:,s_sink_i) = s_sink_p;
    m.morphogens(:,id_lip_i) = id_lip_p;
    m.morphogens(:,id_lipcliff_i) = id_lipcliff_p;
    m.morphogens(:,v_speckareal_i) = v_speckareal_p;
    m.morphogens(:,v_specaniso_i) = v_specaniso_p;
    m.morphogens(:,id_early_i) = id_early_p;
    m.morphogens(:,id_palate_i) = id_palate_p;
    m.morphogens(:,id_hinge_i) = id_hinge_p;
    m.morphogens(:,id_ventmidvein_i) = id_ventmidvein_p;
    m.morphogens(:,id_latsecvein_i) = id_latsecvein_p;
    m.morphogens(:,s_ventmidvein_i) = s_ventmidvein_p;
    m.morphogens(:,s_latsecvein_i) = s_latsecvein_p;
    m.morphogens(:,id_vent_i) = id_vent_p;
    m.morphogens(:,s_vent_i) = s_vent_p;
    m.morphogens(:,id_lat_i) = id_lat_p;
    m.morphogens(:,id_latrad_i) = id_latrad_p;
    m.morphogens(:,v_kaniso_i) = v_kaniso_p;
    m.morphogens(:,id_lipbend_i) = id_lipbend_p;
    m.morphogens(:,id_tube_i) = id_tube_p;

%%% USER CODE: FINALISATION

% In this section you may modify the mesh in any way whatsoever.

% If needed force FE to subdivide (increase number FE's) here
if (Steps(m)==3)
m = leaf_subdivide( m, 'morphogen','id_rim',...
      'min',0.5,'max',1,...
      'mode','mid','levels','all');
end

if (Steps(m)==4)
m = leaf_subdivide( m, 'morphogen','id_lipcliff',...
      'min',0.5,'max',1,...
      'mode','mid','levels','all');
end
% Cut the mesh along the seams (see above)
% if m.userdata.CutOpen==1
%    m=leaf_dissect(m);
%    m.userdata.CutOpen=2;
%    Relax accumulated stresses slowly i.e. 0.95 to 0.999
%    m = leaf_setproperty( m, 'freezing', 0.999 );
% end
%%% END OF USER CODE: FINALISATION

end


%%% USER CODE: SUBFUNCTIONS

function m = local_setproperties( m )
% This function is called at time zero in the INITIALISATION section of the
% interaction function.  It provides commands to set each of the properties
% that are contained in m.globalProps.  Uncomment whichever ones you would
% like to set yourself, and put in whatever value you want.
%
% Some of these properties are for internal use only and should never be
% set by the user.  At some point these will be moved into a different
% component of m, but for the present, just don't change anything unless
% you know what it is you're changing.

%    m = leaf_setproperty( m, 'trinodesvalid', true );
%    m = leaf_setproperty( m, 'prismnodesvalid', true );
%    m = leaf_setproperty( m, 'thicknessRelative', 0.200000 );
%    m = leaf_setproperty( m, 'thicknessArea', 0.000000 );
%    m = leaf_setproperty( m, 'thicknessMode', 'physical' );
%    m = leaf_setproperty( m, 'activeGrowth', 1.000000 );
%    m = leaf_setproperty( m, 'displayedGrowth', 1.000000 );
%    m = leaf_setproperty( m, 'displayedMulti', [] );
%    m = leaf_setproperty( m, 'allowNegativeGrowth', true );
%    m = leaf_setproperty( m, 'usePrevDispAsEstimate', true );
%    m = leaf_setproperty( m, 'perturbInitGrowthEstimate', 0.000010 );
%    m = leaf_setproperty( m, 'perturbRelGrowthEstimate', 0.010000 );
%    m = leaf_setproperty( m, 'perturbDiffusionEstimate', 0.000100 );
%    m = leaf_setproperty( m, 'resetRand', false );
%    m = leaf_setproperty( m, 'mingradient', 0.000000 );
%    m = leaf_setproperty( m, 'relativepolgrad', false );
%    m = leaf_setproperty( m, 'usefrozengradient', true );
%    m = leaf_setproperty( m, 'userpolarisation', false );
%    m = leaf_setproperty( m, 'thresholdsq', 0.105169 );
%    m = leaf_setproperty( m, 'splitmargin', 1.400000 );
%    m = leaf_setproperty( m, 'splitmorphogen', '' );
%    m = leaf_setproperty( m, 'thresholdmgen', 0.500000 );
%    m = leaf_setproperty( m, 'bulkmodulus', 1.000000 );
%    m = leaf_setproperty( m, 'unitbulkmodulus', true );
%    m = leaf_setproperty( m, 'poissonsRatio', 0.300000 );
%    m = leaf_setproperty( m, 'starttime', 0.000000 );
%    m = leaf_setproperty( m, 'timestep', 0.010000 );
%    m = leaf_setproperty( m, 'timeunitname', '' );
%    m = leaf_setproperty( m, 'distunitname', 'mm' );
%    m = leaf_setproperty( m, 'scalebarvalue', 0.000000 );
%    m = leaf_setproperty( m, 'validateMesh', true );
%    m = leaf_setproperty( m, 'rectifyverticals', false );
%    m = leaf_setproperty( m, 'allowSplitLongFEM', true );
%    m = leaf_setproperty( m, 'longSplitThresholdPower', 0.000000 );
%    m = leaf_setproperty( m, 'allowSplitBentFEM', false );
%    m = leaf_setproperty( m, 'allowSplitBio', true );
%    m = leaf_setproperty( m, 'allowFlipEdges', false );
%    m = leaf_setproperty( m, 'allowElideEdges', true );
%    m = leaf_setproperty( m, 'mincellangle', 0.200000 );
%    m = leaf_setproperty( m, 'alwaysFlat', 0.000000 );
%    m = leaf_setproperty( m, 'flattenforceconvex', true );
%    m = leaf_setproperty( m, 'flatten', false );
%    m = leaf_setproperty( m, 'flattenratio', 1.000000 );
%    m = leaf_setproperty( m, 'useGrowthTensors', false );
%    m = leaf_setproperty( m, 'plasticGrowth', false );
%    m = leaf_setproperty( m, 'maxFEcells', 0 );
%    m = leaf_setproperty( m, 'inittotalcells', 0 );
%    m = leaf_setproperty( m, 'bioApresplitproc', '' );
%    m = leaf_setproperty( m, 'bioApostsplitproc', '' );
%    m = leaf_setproperty( m, 'maxBioAcells', 0 );
%    m = leaf_setproperty( m, 'biosplitarea', 0.000000 );
%    m = leaf_setproperty( m, 'biosplitarrestmgen', 'ARREST' );
%    m = leaf_setproperty( m, 'biosplitarrestmgenthreshold', 0.990000 );
%    m = leaf_setproperty( m, 'colors', (6 values) );
%    m = leaf_setproperty( m, 'colorvariation', 0.050000 );
%    m = leaf_setproperty( m, 'colorparams', (12 values) );
%    m = leaf_setproperty( m, 'biocolormode', 'auto' );
%    m = leaf_setproperty( m, 'freezing', 0.000000 );
%    m = leaf_setproperty( m, 'canceldrift', false );
%    m = leaf_setproperty( m, 'mgen_interaction', [] );
%    m = leaf_setproperty( m, 'mgen_interactionName', 'gpt_model11_20140612' );
%    m = leaf_setproperty( m, 'allowInteraction', true );
%    m = leaf_setproperty( m, 'interactionValid', true );
%    m = leaf_setproperty( m, 'gaussInfo', (unknown type ''struct'') );
%    m = leaf_setproperty( m, 'D', (36 values) );
%    m = leaf_setproperty( m, 'C', (36 values) );
%    m = leaf_setproperty( m, 'G', (6 values) );
%    m = leaf_setproperty( m, 'solver', 'cgs' );
%    m = leaf_setproperty( m, 'solverprecision', 'double' );
%    m = leaf_setproperty( m, 'solvertolerance', 0.001000 );
%    m = leaf_setproperty( m, 'solvertolerancemethod', 'max' );
%    m = leaf_setproperty( m, 'diffusiontolerance', 0.000010 );
%    m = leaf_setproperty( m, 'allowsparse', true );
%    m = leaf_setproperty( m, 'maxIters', 0 );
%    m = leaf_setproperty( m, 'maxsolvetime', 1000.000000 );
%    m = leaf_setproperty( m, 'cgiters', 0 );
%    m = leaf_setproperty( m, 'simsteps', 0 );
%    m = leaf_setproperty( m, 'stepsperrender', 0 );
%    m = leaf_setproperty( m, 'growthEnabled', true );
%    m = leaf_setproperty( m, 'diffusionEnabled', true );
%    m = leaf_setproperty( m, 'flashmovie', false );
%    m = leaf_setproperty( m, 'makemovie', 0.000000 );
%    m = leaf_setproperty( m, 'moviefile', '' );
%    m = leaf_setproperty( m, 'codec', 'None' );
%    m = leaf_setproperty( m, 'autonamemovie', true );
%    m = leaf_setproperty( m, 'overwritemovie', false );
%    m = leaf_setproperty( m, 'framesize', [] );
%    m = leaf_setproperty( m, 'mov', [] );
%    m = leaf_setproperty( m, 'boingNeeded', false );
%    m = leaf_setproperty( m, 'initialArea', 4.000000 );
%    m = leaf_setproperty( m, 'bendunitlength', 2.000000 );
%    m = leaf_setproperty( m, 'targetRelArea', 1.000000 );
%    m = leaf_setproperty( m, 'defaultinterp', 'min' );
%    m = leaf_setproperty( m, 'readonly', false );
%    m = leaf_setproperty( m, 'projectdir', 'C:\Users\Xana\Desktop\Modelling for Palate paper' );
%    m = leaf_setproperty( m, 'modelname', 'GPT_model11_20140612' );
%    m = leaf_setproperty( m, 'allowsave', 1.000000 );
%    m = leaf_setproperty( m, 'addedToPath', true );
%    m = leaf_setproperty( m, 'bendsplit', 0.300000 );
%    m = leaf_setproperty( m, 'usepolfreezebc', false );
%    m = leaf_setproperty( m, 'dorsaltop', true );
%    m = leaf_setproperty( m, 'defaultazimuth', -45.000000 );
%    m = leaf_setproperty( m, 'defaultelevation', 33.750000 );
%    m = leaf_setproperty( m, 'defaultroll', 0.000000 );
%    m = leaf_setproperty( m, 'defaultViewParams', (unknown type ''struct'') );
%    m = leaf_setproperty( m, 'comment', '' );
%    m = leaf_setproperty( m, 'legendTemplate', '%T: %q\n%m' );
%    m = leaf_setproperty( m, 'bioAsplitcells', true );
%    m = leaf_setproperty( m, 'bioApullin', 0.142857 );
%    m = leaf_setproperty( m, 'bioAfakepull', 0.202073 );
%    m = leaf_setproperty( m, 'interactive', false );
%    m = leaf_setproperty( m, 'coderevision', 5038.000000 );
%    m = leaf_setproperty( m, 'coderevisiondate', '2014-06-09 12:52:56' );
%    m = leaf_setproperty( m, 'modelrevision', 0.000000 );
%    m = leaf_setproperty( m, 'modelrevisiondate', '' );
%    m = leaf_setproperty( m, 'savedrunname', '' );
%    m = leaf_setproperty( m, 'savedrundesc', '' );
%    m = leaf_setproperty( m, 'vxgrad', (108 values) );
%    m = leaf_setproperty( m, 'lengthscale', 2.000000 );
%    m = leaf_setproperty( m, 'mincellrelarea', 0.040000 );
%    m = leaf_setproperty( m, 'viewrotationstart', -45.000000 );
%    m = leaf_setproperty( m, 'viewrotationperiod', 0.000000 );
end

% Here you may write any functions of your own, that you want to call from
% the interaction function, but never need to call from outside it.
% Remember that they do not have access to any variables except those
% that you pass as parameters, and cannot change anything except by
% returning new values as results.
% Whichever section they are called from, they must respect the same
% restrictions on what modifications they are allowed to make to the mesh.

% For example:

% function m = do_something( m )
%   % Change m in some way.
% end

% Call it from the main body of the interaction function like this:
%       m = do_something( m );
