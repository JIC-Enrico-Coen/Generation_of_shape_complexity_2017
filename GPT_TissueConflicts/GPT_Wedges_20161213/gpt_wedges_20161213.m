function m = gpt_wedges_20161213( m )
%m = gpt_wedges_20161213( m )
%   Morphogen interaction function.
%   Written at 2016-12-13 16:33:43.
%   GFtbox revision 5454, 2016-08-30 15:40.

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

    m=leaf_plotoptions(m,'layeroffset', 0.2);    
    % set colour of polariser gradient arrows
    m=leaf_plotoptions(m,'highgradcolor',[0,0,0],'lowgradcolor',[1,0,0]);
    m=leaf_plotoptions(m,'decorscale',1.5);
    m=leaf_plotoptions(m,'arrowthickness',1.5);
    m=leaf_plotoptions(m,'sidegrad','AB'); %polariser gradient will be plotted on both sides
if (Steps(m)==0) && m.globalDynamicProps.doinit % First iteration
    
    % Set up names for variant models.  Useful for running multiple models on a cluster.
    
    m.userdata.ranges.modelname.range {1} = 'Figure 9 A-F. Phase I + II of div domes'; %div model with two morphogenetic switch at day 12 when boosting the model4 growth rates in kper and kpar to produce cell files and then reducing then from day 15 to make shape
    m.userdata.ranges.modelname.range {2} = 'Figure 9J. No orthogonal conflict'; %div model with two morphogenetic switch at day 12 when boosting the model4 growth rates in kper and kpar to produce cell files and then reducing then from day 15 to make shape
    m.userdata.ranges.modelname.range {3} = 'Figure 9I. No directional conflict and specified anisotropy'; %div model with two morphogenetic switch at day 12 when boosting the model4 growth rates in kper and kpar to produce cell files and then reducing then from day 15 to make shape
    m.userdata.ranges.modelname.range {4} = 'Figure 9G. No surface conflict'; %div model with two morphogenetic switch at day 12 when boosting the model4 growth rates in kper and kpar to produce cell files and then reducing then from day 15 to make shape
    m.userdata.ranges.modelname.range {5} = 'Figure 9H. No areal conflict'; %div model with two morphogenetic switch at day 12 when boosting the model4 growth rates in kper and kpar to produce cell files and then reducing then from day 15 to make shape
    m.userdata.ranges.modelname.range {6} = 'WT_criss-cross'; %div model with two morphogenetic switch at day 12 when boosting the model4 growth rates in kper and kpar to produce cell files and then reducing then from day 15 to make shape
    m.userdata.ranges.modelname.range {7} = 'Figure 10A-F.   Phase I + II of wild-type wedge'; %WT model with two morphogenetic switch at day 12 when boosting the model4 growth rates in kper and kpar to produce cell files and then reducing then from day 15 to make shape
    m.userdata.ranges.modelname.range {8} = 'WT_criss-cross + sinus_A+B'; %WT model based on model6 from palate&lip modelling
    m.userdata.ranges.modelname.range {9} = 'Figure 10I. No directional conflict'; %WT model with two morphogenetic switch at day 12 when boosting the model4 growth rates in kper and kpar to produce cell files and then reducing then from day 15 to make shape
    m.userdata.ranges.modelname.range {10} = 'Figure 10J. No orthogonal directional conflict'; %WT model with two morphogenetic switch at day 12 when boosting the model4 growth rates in kper and kpar to produce cell files and then reducing then from day 15 to make shape
    m.userdata.ranges.modelname.range {11} = 'Figure 10G. No surface conflict'; %WT model with two morphogenetic switch at day 12 when boosting the model4 growth rates in kper and kpar to produce cell files and then reducing then from day 15 to make shape
    m.userdata.ranges.modelname.range {12} = 'Figure 10H. No areal conflict'; %WT model with two morphogenetic switch at day 12 when boosting the model4 growth rates in kper and kpar to produce cell files and then reducing then from day 15 to make shape
    m.userdata.ranges.modelname.range {13} = 'WT_timing all at day 10'; %WT model with two morphogenetic switch at day 12 when boosting the model4 growth rates in kper and kpar to produce cell files and then reducing then from day 15 to make shape
    m.userdata.ranges.modelname.index =11;                       % CLUSTER
    
    
    %m = leaf_setzeroz( m ); % keeps the noise in the canvas to zero
    m = leaf_bowlz(m, 0.01 ); %induce a slightly curve in the medio-lateral axis of the canvas
    m = leaf_setthickness(m, 0.06); %thickness of canvas, relates to the 60 um of the real data
    
    %     %ID_EDGE
    %    m = leaf_mgen_edge( m, 'ID_EDGE', 1);
    % %     id_edge_p = m.morphogens(:,id_edge_i);
    %
    %    m = leaf_fix_vertex( m, 'ID_EDGE', 'dfs', 'z' );
    %  m = leaf_fix_vertex( m, 'vertex', find(m.nodes(:,2)>=min(m.nodes(:,2)+0.01)), 'dfs', 'y' );
    %     m = leaf_fix_vertex( m, 'vertex', find(m.nodes(:,2)>=max(m.nodes(:,2)-0.01)), 'dfs', 'z' );
    %
    %m = leaf_fix_vertex( m, 'vertex', find(m.nodes(:,1)<=min(m.nodes(:,1)+0.01)), 'dfs', 'xyz' );
    %m = leaf_fix_vertex( m, 'vertex', find(m.nodes(:,1)>=max(m.nodes(:,1)-0.01)), 'dfs', 'xyz' );
    

    
    m.globalProps.timestep=10; %each step relates to 10 hours in real time
    
    
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

    polariser_i = FindMorphogenRole( m, 'POLARISER' );
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
    [id_med_i,id_med_p,id_med_a,id_med_l] = getMgenLevels( m, 'ID_MED' );
    [id_junction_i,id_junction_p,id_junction_a,id_junction_l] = getMgenLevels( m, 'ID_JUNCTION' );
    [id_rim_i,id_rim_p,id_rim_a,id_rim_l] = getMgenLevels( m, 'ID_RIM' );
    [s_source_i,s_source_p,s_source_a,s_source_l] = getMgenLevels( m, 'S_SOURCE' );
    [s_rim_i,s_rim_p,s_rim_a,s_rim_l] = getMgenLevels( m, 'S_RIM' );
    [s_med_i,s_med_p,s_med_a,s_med_l] = getMgenLevels( m, 'S_MED' );
    [s_lat_i,s_lat_p,s_lat_a,s_lat_l] = getMgenLevels( m, 'S_LAT' );
    [v_flower_i,v_flower_p,v_flower_a,v_flower_l] = getMgenLevels( m, 'V_FLOWER' );
    [id_spotty_i,id_spotty_p,id_spotty_a,id_spotty_l] = getMgenLevels( m, 'ID_SPOTTY' );
    [id_stripy_i,id_stripy_p,id_stripy_a,id_stripy_l] = getMgenLevels( m, 'ID_STRIPY' );
    [id_late_i,id_late_p,id_late_a,id_late_l] = getMgenLevels( m, 'ID_LATE' );
    [id_sinus_i,id_sinus_p,id_sinus_a,id_sinus_l] = getMgenLevels( m, 'ID_SINUS' );
    [s_sinus_i,s_sinus_p,s_sinus_a,s_sinus_l] = getMgenLevels( m, 'S_SINUS' );
    [s_sink_i,s_sink_p,s_sink_a,s_sink_l] = getMgenLevels( m, 'S_SINK' );
    [id_lipcliff_i,id_lipcliff_p,id_lipcliff_a,id_lipcliff_l] = getMgenLevels( m, 'ID_LIPCLIFF' );
    [v_speckareal_i,v_speckareal_p,v_speckareal_a,v_speckareal_l] = getMgenLevels( m, 'V_SPECKAREAL' );
    [v_specaniso_i,v_specaniso_p,v_specaniso_a,v_specaniso_l] = getMgenLevels( m, 'V_SPECANISO' );
    [id_early_i,id_early_p,id_early_a,id_early_l] = getMgenLevels( m, 'ID_EARLY' );
    [id_palate_i,id_palate_p,id_palate_a,id_palate_l] = getMgenLevels( m, 'ID_PALATE' );
    [id_hinge_i,id_hinge_p,id_hinge_a,id_hinge_l] = getMgenLevels( m, 'ID_HINGE' );
    [id_ventmidvein_i,id_ventmidvein_p,id_ventmidvein_a,id_ventmidvein_l] = getMgenLevels( m, 'ID_VENTMIDVEIN' );
    [id_secvein_i,id_secvein_p,id_secvein_a,id_secvein_l] = getMgenLevels( m, 'ID_SECVEIN' );
    [s_ventmidvein_i,s_ventmidvein_p,s_ventmidvein_a,s_ventmidvein_l] = getMgenLevels( m, 'S_VENTMIDVEIN' );
    [s_secvein_i,s_secvein_p,s_secvein_a,s_secvein_l] = getMgenLevels( m, 'S_SECVEIN' );
    [id_div_i,id_div_p,id_div_a,id_div_l] = getMgenLevels( m, 'ID_DIV' );
    [s_div_i,s_div_p,s_div_a,s_div_l] = getMgenLevels( m, 'S_DIV' );
    [id_lat_i,id_lat_p,id_lat_a,id_lat_l] = getMgenLevels( m, 'ID_LAT' );
    [v_kaniso_i,v_kaniso_p,v_kaniso_a,v_kaniso_l] = getMgenLevels( m, 'V_KANISO' );
    [id_lipbend_i,id_lipbend_p,id_lipbend_a,id_lipbend_l] = getMgenLevels( m, 'ID_LIPBEND' );
    [id_tube_i,id_tube_p,id_tube_a,id_tube_l] = getMgenLevels( m, 'ID_TUBE' );
    [id_rad_i,id_rad_p,id_rad_a,id_rad_l] = getMgenLevels( m, 'ID_RAD' );
    [s_rad_i,s_rad_p,s_rad_a,s_rad_l] = getMgenLevels( m, 'S_RAD' );
    [id_lipdistal_i,id_lipdistal_p,id_lipdistal_a,id_lipdistal_l] = getMgenLevels( m, 'ID_LIPDISTAL' );
    [id_lip_i,id_lip_p,id_lip_a,id_lip_l] = getMgenLevels( m, 'ID_LIP' );
    [id_twinpeaks_i,id_twinpeaks_p,id_twinpeaks_a,id_twinpeaks_l] = getMgenLevels( m, 'ID_TWINPEAKS' );
    [id_cheeks_i,id_cheeks_p,id_cheeks_a,id_cheeks_l] = getMgenLevels( m, 'ID_CHEEKS' );
    [id_foci_i,id_foci_p,id_foci_a,id_foci_l] = getMgenLevels( m, 'ID_FOCI' );
    [s_foci_i,s_foci_p,s_foci_a,s_foci_l] = getMgenLevels( m, 'S_FOCI' );
    [id_dorsaledge_i,id_dorsaledge_p,id_dorsaledge_a,id_dorsaledge_l] = getMgenLevels( m, 'ID_DORSALEDGE' );
    [s_dorsaledge_i,s_dorsaledge_p,s_dorsaledge_a,s_dorsaledge_l] = getMgenLevels( m, 'S_DORSALEDGE' );
    [v_diff_i,v_diff_p,v_diff_a,v_diff_l] = getMgenLevels( m, 'V_DIFF' );
    [id_lobe_i,id_lobe_p,id_lobe_a,id_lobe_l] = getMgenLevels( m, 'ID_LOBE' );
    [id_subdivision_i,id_subdivision_p,id_subdivision_a,id_subdivision_l] = getMgenLevels( m, 'ID_SUBDIVISION' );
    [s_hinge_i,s_hinge_p,s_hinge_a,s_hinge_l] = getMgenLevels( m, 'S_HINGE' );
    [id_time_i,id_time_p,id_time_a,id_time_l] = getMgenLevels( m, 'ID_TIME' );
    [glate_i,glate_p,glate_a,glate_l] = getMgenLevels( m, 'GLATE' );
    [id_fixvertex_i,id_fixvertex_p,id_fixvertex_a,id_fixvertex_l] = getMgenLevels( m, 'ID_FIXVERTEX' );
    [id_palateprox_i,id_palateprox_p,id_palateprox_a,id_palateprox_l] = getMgenLevels( m, 'ID_PALATEPROX' );
    [id_brim_i,id_brim_p,id_brim_a,id_brim_l] = getMgenLevels( m, 'ID_BRIM' );
    [id_pltdistal_i,id_pltdistal_p,id_pltdistal_a,id_pltdistal_l] = getMgenLevels( m, 'ID_PLTDISTAL' );
    [v_karea_i,v_karea_p,v_karea_a,v_karea_l] = getMgenLevels( m, 'V_KAREA' );
    [id_palatedi_i,id_palatedi_p,id_palatedi_a,id_palatedi_l] = getMgenLevels( m, 'ID_PALATEDI' );
    [v_kareaa_i,v_kareaa_p,v_kareaa_a,v_kareaa_l] = getMgenLevels( m, 'V_KAREAA' );
    [v_kareab_i,v_kareab_p,v_kareab_a,v_kareab_l] = getMgenLevels( m, 'V_KAREAB' );

% Mesh type: rectangle
%            base: 0
%          centre: 0
%          layers: 0
%      randomness: 0.001
%       thickness: 0
%           xdivs: 159
%          xwidth: 1.06
%           ydivs: 12
%          ywidth: 0.08

%            Morphogen    Diffusion   Decay   Dilution   Mutant
%            --------------------------------------------------
%                KAPAR         ----    ----       ----     ----
%                KAPER         ----    ----       ----     ----
%                KBPAR         ----    ----       ----     ----
%                KBPER         ----    ----       ----     ----
%                 KNOR         ----    ----       ----     ----
%            POLARISER       0.0001   0.001       ----     ----
%            STRAINRET         ----    ----       ----     ----
%               ARREST         ----    ----       ----     ----
%              ID_SINK         ----    ----       ----     ----
%            ID_SOURCE         ----    ----       ----     ----
%              ID_EDGE         ----    ----       ----     ----
%               ID_MED         ----    ----       ----     ----
%          ID_JUNCTION         ----    ----       ----     ----
%               ID_RIM         ----    ----       ----     ----
%             S_SOURCE         ----    ----       ----     ----
%                S_RIM         ----    ----       ----     ----
%                S_MED         ----    ----       ----     ----
%                S_LAT         ----    ----       ----     ----
%             V_FLOWER         ----    ----       ----     ----
%            ID_SPOTTY         ----    ----       ----     ----
%            ID_STRIPY         ----    ----       ----     ----
%              ID_LATE         ----    ----       ----     ----
%             ID_SINUS         ----    ----       ----     ----
%              S_SINUS       0.0001     0.1       ----     ----
%               S_SINK         ----    ----       ----     ----
%          ID_LIPCLIFF         ----    ----       ----     ----
%         V_SPECKAREAL         ----    ----       ----     ----
%          V_SPECANISO         ----    ----       ----     ----
%             ID_EARLY         ----    ----       ----     ----
%            ID_PALATE         ----    ----       ----     ----
%             ID_HINGE         ----    ----       ----     ----
%       ID_VENTMIDVEIN         ----    ----       ----     ----
%           ID_SECVEIN         ----    ----       ----     ----
%        S_VENTMIDVEIN         ----    0.02       ----     ----
%            S_SECVEIN         ----    ----       ----     ----
%               ID_DIV         ----    ----       ----     ----
%                S_DIV         ----    ----       ----     ----
%               ID_LAT         ----    ----       ----     ----
%             V_KANISO         ----    ----       ----     ----
%           ID_LIPBEND         ----    ----       ----     ----
%              ID_TUBE         ----    ----       ----     ----
%               ID_RAD         ----    ----       ----     ----
%                S_RAD         ----    ----       ----     ----
%         ID_LIPDISTAL         ----    ----       ----     ----
%               ID_LIP         ----    ----       ----     ----
%         ID_TWINPEAKS         ----    ----       ----     ----
%            ID_CHEEKS         ----    ----       ----     ----
%              ID_FOCI         ----    ----       ----     ----
%               S_FOCI        1e-05  0.0001       ----     ----
%        ID_DORSALEDGE         ----    ----       ----     ----
%         S_DORSALEDGE         ----    ----       ----     ----
%               V_DIFF         ----    ----       ----     ----
%              ID_LOBE         ----    ----       ----     ----
%       ID_SUBDIVISION         ----    ----       ----     ----
%              S_HINGE       0.0001   0.001       ----     ----
%              ID_TIME         ----    ----       ----     ----
%                GLATE         ----    ----       ----     ----
%         ID_FIXVERTEX         ----    ----       ----     ----
%        ID_PALATEPROX         ----    ----       ----     ----
%              ID_BRIM         ----    ----       ----     ----
%         ID_PLTDISTAL         ----    ----       ----     ----
%              V_KAREA         ----    ----       ----     ----
%          ID_PALATEDI         ----    ----       ----     ----
%             V_KAREAA         ----    ----       ----     ----
%             V_KAREAB         ----    ----       ----     ----


%%% USER CODE: MORPHOGEN INTERACTIONS
% In this section you may modify the mesh in any way that does not
% alter the set of nodes.

%             %ID_SUBDIVISION - Region that subdivides
%             id_subdivision_p (m.nodes(:,2) < 0.0391 & m.nodes(:,2) > - 0.0151) = 1

%   m = leaf_fix_vertex( m, 'ID_EDGE', 'dfs', 'z' );


if (Steps(m)==1) && m.globalDynamicProps.doinit  % Initialisation code.
    
    m = leaf_setproperty (m, ...
        'twosidedpolarisation', true, ... % the mesh has two-sided polarisation
        'mingradient', 0.0, ... % No threshold for freezing the polariser
        'usedpolfreezebc', true); % a rather subtle choice of a feature of the behaviour of frozen gradients. It probably doesn't make much difference.
    
    m = leaf_setpolfrozen (m, false); %Initially the gradient is not frozen anywhere
    
    switch modelname
        
        case {'Figure 10I. No directional conflict', 'Figure 9I. No directional conflict and specified anisotropy'}
            
            m = leaf_mgen_conductivity( m, 'POLARISER', 0 );  %specifies the diffusion rate of polariser
            m = leaf_mgen_absorption( m, 'POLARISER', 0 );     % specifies degradation rate of polariser
%             bottom = m.nodes(:,2) == min(m.nodes(:,2));
%             top = m.nodes(:,2)== max(m.nodes(:,2));
%             id_sink_p(top) = 1;
%             id_source_p(bottom) = 1;
%             P(bottom) = 1;
%             P(top) = 0.5;
%             m.morphogenclamp(bottom, polariser_i) = 1;
%             m.morphogenclamp(top, polariser_i) = 1;
            
            %Dorso-Ventral Regional factors (IDs) and Signals (Ss)
            
            %ID_DIV
            id_div_p (:) = 1;
            
            %S_DIV
            s_div_p(:) = 0;
            s_div_p(:) = id_div_p(:);
            m = leaf_mgen_conductivity( m, 'S_DIV', 0.0005 );
            m = leaf_mgen_absorption( m, 'S_DIV', 0.005 );
            
            %ID_RAD
            id_rad_p (m.nodes(:,1) < - 0.51 | m.nodes(:,1) > 0.51) = 1;
            
            %S_RAD
            s_rad_p(:) = 0;
            s_rad_p(:) = 2*id_rad_p(:);
            m = leaf_mgen_conductivity( m, 'S_RAD', 0.0001 );
            m = leaf_mgen_absorption( m, 'S_RAD', 0.01 );
            
            %ID_HINGE
            id_hinge_p (m.nodes(:,1) < - 0.35 | m.nodes(:,1) > 0.35) = 1;
            
            %Proximo-distal Regional factors (IDs) and Signals (Ss)
            
            %ID_RIM
            id_rim_p (:) = 0;
            id_rim_p(m.nodes(:,2) < 0.01 & m.nodes(:,2) > - 0.01) = 1;
            
            %S_RIM
            s_rim_p(:) = 0;
            s_rim_p(:) = id_rim_p;
            m = leaf_mgen_conductivity( m, 'S_RIM', 0.000001 );
            m = leaf_mgen_absorption( m, 'S_RIM', 0.01);
            
            %ID_LIP
            id_lip_p (:) = 0;
            id_lip_p (m.nodes(:,2)  > 0.0099) = 1;
            
            %ID_LIPDISTAL
            id_lipdistal_p (:) = 0;
            id_lipdistal_p(m.nodes(:,2)  > 0.03) = 1;
            
            %ID_LIPCLIFF
            id_lipcliff_p (:) = 0;
            id_lipcliff_p (m.nodes(:,2) < 0.03 & m.nodes(:,2) > 0.0099) = 1;
            
            %PALATE
            id_palate_p (:) = 0;
            id_palate_p (m.nodes(:,2) < - 0.01) = 1;
            
            %PALATE DISTAL
            id_palatedi_p (:) = 0;
            id_palatedi_p (m.nodes(:,2) < - 0.01 & m.nodes(:,2) > - 0.03) = 1;
            
            %PALATE PROX
            id_palateprox_p (:) = 0;
            id_palateprox_p (m.nodes(:,2) < - 0.03) = 1;
            
            %Medio-Lateral Regional factors (IDs) and Signals (Ss)
            
            %id_lat
            id_lat_p((m.nodes(:,1) < 0.180 & m.nodes(:,1) > 0.162)) = 1;
            id_lat_p((m.nodes(:,1) > - 0.180 & m.nodes(:,1) < - 0.162) ) = 1;
            id_lat_p((m.nodes(:,1) > 0.51 | m.nodes(:,1) < - 0.51) ) = 1;
            
            %s_lat
            s_lat_p = 3*id_lat_p .* inh (0.65, id_rad_p);
            m = leaf_mgen_conductivity( m, 's_LAT', 0.00002 );
            m = leaf_mgen_absorption( m, 's_LAT', 0.0002 );
            
            %ID_MED
            id_med_p (m.nodes(:,1) > 0.335 & m.nodes(:,1) < 0.35) = 1;
            id_med_p (m.nodes(:,1) < - 0.335 & m.nodes(:,1) > - 0.35) = 1;
            id_med_p (m.nodes(:,1) > - 0.008 & m.nodes(:,1) < 0.008) = 1;
            
            %S_MED
            s_med_p(:) = 0;
            s_med_p(:) = 5*id_med_p(:);
            m = leaf_mgen_conductivity( m, 'S_MED', 0.00002 );
            m = leaf_mgen_absorption( m, 'S_MED', 0.0002 );
            
            %ID_secvein
            id_secvein_p (m.nodes(:,1) > 0.241 & m.nodes(:,1) < 0.252) = 1;
            id_secvein_p (m.nodes(:,1) < - 0.241 & m.nodes(:,1) > - 0.252) = 1;
            id_secvein_p (m.nodes(:,1) > 0.431 & m.nodes(:,1) < 0.447) = 1;
            id_secvein_p (m.nodes(:,1) < - 0.431 & m.nodes(:,1) > - 0.447) = 1;
            id_secvein_p (m.nodes(:,1) > 0.085 & m.nodes(:,1) < 0.097) = 1;
            id_secvein_p (m.nodes(:,1) < - 0.085 & m.nodes(:,1) > - 0.097) = 1;
            
            %S_secvein
            s_secvein_p(:) = 0;
            s_secvein_p(:) = 5*id_secvein_p(:);
            m = leaf_mgen_conductivity( m, 'S_SECVEIN', 0.00001 );
            m = leaf_mgen_absorption( m, 'S_SECVEIN', 0.01 );
            
            %Other factors
            
            %S_SOURCE
            s_source_p(:) = 0;
            s_source_p(:) = 5*id_source_p;
            m = leaf_mgen_conductivity( m, 'S_SOURCE', 0.00002 );
            m = leaf_mgen_absorption( m, 'S_SOURCE', 0.0002 );
            
            %S_SINK
            s_sink_p(:) = 0;
            s_sink_p(:) = 5*id_sink_p;
            m = leaf_mgen_conductivity( m, 'S_SINK', 0.000005 );
            m = leaf_mgen_absorption( m, 'S_SINK', 0.00005 );
            
            case { 'Figure 9J. No orthogonal conflict', 'Figure 9 A-F. Phase I + II of div domes','Figure 9G. No surface conflict',...
                    'Figure 9H. No areal conflict', 'WT_criss-cross', 'Figure 10A-F.   Phase I + II of wild-type wedge',...
                    'WT_criss-cross + sinus_A+B', 'Figure 10J. No orthogonal directional conflict', 'Figure 10G. No surface conflict',...
                     'Figure 10H. No areal conflict', 'WT_timing all at day 10'}
            
            m = leaf_mgen_conductivity( m, 'POLARISER', 0.0001 );  %specifies the diffusion rate of polariser
            m = leaf_mgen_absorption( m, 'POLARISER', 0.001 );     % specifies degradation rate of polariser
            bottom = m.nodes(:,2) == min(m.nodes(:,2));
            top = m.nodes(:,2)== max(m.nodes(:,2));
            id_sink_p(top) = 1;
            id_source_p(bottom) = 1;
            P(bottom) = 1;
            P(top) = 0.5;
            m.morphogenclamp(bottom, polariser_i) = 1;
            m.morphogenclamp(top, polariser_i) = 1;
            
            %Dorso-Ventral Regional factors (IDs) and Signals (Ss)
            
            %ID_DIV
            id_div_p (:) = 1;
            
            %S_DIV
            s_div_p(:) = 0;
            s_div_p(:) = id_div_p(:);
            m = leaf_mgen_conductivity( m, 'S_DIV', 0.0005 );
            m = leaf_mgen_absorption( m, 'S_DIV', 0.005 );
            
            %ID_RAD
            id_rad_p (m.nodes(:,1) < - 0.51 | m.nodes(:,1) > 0.51) = 1;
            
            %S_RAD
            s_rad_p(:) = 0;
            s_rad_p(:) = 2*id_rad_p(:);
            m = leaf_mgen_conductivity( m, 'S_RAD', 0.0001 );
            m = leaf_mgen_absorption( m, 'S_RAD', 0.01 );
            
            %ID_HINGE
            id_hinge_p (m.nodes(:,1) < - 0.35 | m.nodes(:,1) > 0.35) = 1;
            
            %Proximo-distal Regional factors (IDs) and Signals (Ss)
            
            %ID_RIM
            id_rim_p (:) = 0;
            id_rim_p(m.nodes(:,2) < 0.01 & m.nodes(:,2) > - 0.01) = 1;
            
            %S_RIM
            s_rim_p(:) = 0;
            s_rim_p(:) = id_rim_p;
            m = leaf_mgen_conductivity( m, 'S_RIM', 0.000001 );
            m = leaf_mgen_absorption( m, 'S_RIM', 0.01);
            
            %ID_LIP
            id_lip_p (:) = 0;
            id_lip_p (m.nodes(:,2)  > 0.0099) = 1;
            
            %ID_LIPDISTAL
            id_lipdistal_p (:) = 0;
            id_lipdistal_p(m.nodes(:,2)  > 0.03) = 1;
            
            %ID_LIPCLIFF
            id_lipcliff_p (:) = 0;
            id_lipcliff_p (m.nodes(:,2) < 0.03 & m.nodes(:,2) > 0.0099) = 1;
            
            %PALATE
            id_palate_p (:) = 0;
            id_palate_p (m.nodes(:,2) < - 0.01) = 1;
            
            %PALATE DISTAL
            id_palatedi_p (:) = 0;
            id_palatedi_p (m.nodes(:,2) < - 0.01 & m.nodes(:,2) > - 0.03) = 1;
            
            %PALATE PROX
            id_palateprox_p (:) = 0;
            id_palateprox_p (m.nodes(:,2) < - 0.03) = 1;
            
            %Medio-Lateral Regional factors (IDs) and Signals (Ss)
            
            %id_lat
            id_lat_p((m.nodes(:,1) < 0.180 & m.nodes(:,1) > 0.162)) = 1;
            id_lat_p((m.nodes(:,1) > - 0.180 & m.nodes(:,1) < - 0.162) ) = 1;
            id_lat_p((m.nodes(:,1) > 0.51 | m.nodes(:,1) < - 0.51) ) = 1;
            
            %s_lat
            s_lat_p = 3*id_lat_p .* inh (0.65, id_rad_p);
            m = leaf_mgen_conductivity( m, 's_lat', 0.00002 );
            m = leaf_mgen_absorption( m, 's_lat', 0.0002 );
            
            %ID_MED
            id_med_p (m.nodes(:,1) > 0.335 & m.nodes(:,1) < 0.35) = 1;
            id_med_p (m.nodes(:,1) < - 0.335 & m.nodes(:,1) > - 0.35) = 1;
            id_med_p (m.nodes(:,1) > - 0.008 & m.nodes(:,1) < 0.008) = 1;
            
            %S_MED
            s_med_p(:) = 0;
            s_med_p(:) = 5*id_med_p(:);
            m = leaf_mgen_conductivity( m, 'S_MED', 0.00002 );
            m = leaf_mgen_absorption( m, 'S_MED', 0.0002 );
            
            %ID_secvein
            id_secvein_p (m.nodes(:,1) > 0.241 & m.nodes(:,1) < 0.252) = 1;
            id_secvein_p (m.nodes(:,1) < - 0.241 & m.nodes(:,1) > - 0.252) = 1;
            id_secvein_p (m.nodes(:,1) > 0.431 & m.nodes(:,1) < 0.447) = 1;
            id_secvein_p (m.nodes(:,1) < - 0.431 & m.nodes(:,1) > - 0.447) = 1;
            id_secvein_p (m.nodes(:,1) > 0.085 & m.nodes(:,1) < 0.097) = 1;
            id_secvein_p (m.nodes(:,1) < - 0.085 & m.nodes(:,1) > - 0.097) = 1;
            
            %S_secvein
            s_secvein_p(:) = 0;
            s_secvein_p(:) = 5*id_secvein_p(:);
            m = leaf_mgen_conductivity( m, 'S_SECVEIN', 0.00001 );
            m = leaf_mgen_absorption( m, 'S_SECVEIN', 0.01 );
            
            %Other factors
            
            %S_SOURCE
            s_source_p(:) = 0;
            s_source_p(:) = 5*id_source_p;
            m = leaf_mgen_conductivity( m, 'S_SOURCE', 0.00002 );
            m = leaf_mgen_absorption( m, 'S_SOURCE', 0.0002 );
            
            %S_SINK
            s_sink_p(:) = 0;
            s_sink_p(:) = 5*id_sink_p;
            m = leaf_mgen_conductivity( m, 'S_SINK', 0.000005 );
            m = leaf_mgen_absorption( m, 'S_SINK', 0.00005 );
            
            
    end
    
end

if(Steps(m)==5)
    m = leaf_mgen_conductivity( m, 'S_MED', 0 );
    m = leaf_mgen_absorption( m, 'S_MED', 0 );
    m = leaf_mgen_conductivity( m, 'S_SOURCE', 0 );
    m = leaf_mgen_absorption( m, 'S_SOURCE', 0 );
    m = leaf_mgen_conductivity( m, 's_lat', 0 );
    m = leaf_mgen_absorption( m, 's_lat', 0 );
    m = leaf_mgen_conductivity( m, 'S_RIM', 0 );
    m = leaf_mgen_absorption( m, 'S_RIM', 0 );
    m = leaf_mgen_conductivity( m, 'S_SINK', 0 );
    m = leaf_mgen_absorption( m, 'S_SINK', 0 );
    m = leaf_mgen_conductivity( m, 'S_SECVEIN', 0 );
    m = leaf_mgen_absorption( m, 'S_SECVEIN', 0 );
    m = leaf_mgen_conductivity( m, 'S_DIV', 0 );
    m = leaf_mgen_absorption( m, 'S_DIV', 0 );
    m = leaf_mgen_conductivity( m, 'S_RAD', 0);
    m = leaf_mgen_absorption( m, 'S_RAD', 0);
    
    switch modelname
        
        case  {'Figure 9J. No orthogonal conflict', 'Figure 9 A-F. Phase I + II of div domes','Figure 9G. No surface conflict', 'Figure 9I. No directional conflict and specified anisotropy','Figure 9H. No areal conflict', 'WT_criss-cross'}
            
            m = leaf_mgen_conductivity( m, 'POLARISER', 0 );  %specifies the diffusion rate of polariser
            m = leaf_mgen_absorption( m, 'POLARISER', 0 );
            
            %S_DIV
            s_div_p(:) = 0;
            s_div_p(:) = id_div_p .* inh (100, s_rad_p);
            
        case  {'Figure 10A-F.   Phase I + II of wild-type wedge', 'WT_criss-cross + sinus_A+B', 'Figure 10I. No directional conflict',...
                'Figure 10J. No orthogonal directional conflict', 'Figure 10G. No surface conflict',...
                'Figure 10H. No areal conflict','WT_timing all at day 10'}
            
            %S_DIV
            s_div_p(:) = 0;
            s_div_p(:) = id_div_p .* inh (100, s_rad_p);
            
    end
end

if(Steps(m)==12)
    %add clones
    
    m = leaf_makesecondlayer( m, ...  % This function adds biological cells.
        'mode', 'each', ...
        'probpervx', 'V_FLOWER', ... % induce tranls randomly scattered over the flower.
        'relarea', 1/5000, ...   % cell size calculated represent more or less one cell
        'numcells',2500,...%number of cells (that will become clones)
        'sides', 16, ...  % Each cell is approximated as a 6-sided regular polygon.
        'colors', [0.5 0.5 0.5], ...  % Default colour is gray but
        'allowoverlap', false, ...
        'colorvariation',1,... % Each cell is a random colour
        'add', true );  % These cells are added to any cells existing already
    m = leaf_plotoptions( m, 'cellbodyvalue', '' );
    %  m = leaf_setproperty( m, 'biosplitarea', yourpreferredarea ); % WE can specify to which area do cells split
    
end
if(Steps(m)==12)
    switch modelname
        
        %Introducing a new minus organiser at the sinus
        case  {'Figure 10A-F.   Phase I + II of wild-type wedge', 'Figure 10G. No surface conflict', 'Figure 10J. No orthogonal directional conflict',...
                'Figure 10H. No areal conflict', 'WT_timing all at day 10'} %reorientation only at the B side (adaxial)
            
            id_sinus_p = (s_lat_p.^2) .* s_sink_p .* inh (100, id_hinge_p);
            
            m = leaf_mgen_conductivity( m, 'POLARISER', 0.0001 );  %specifies the diffusion rate of polariser
            m = leaf_mgen_absorption( m, 'POLARISER', 0.001 );     % specifies degradation rate of polariser
            P(id_source_p==1) = 1;
            P(id_sink_p==1) = 0.5;
            m.morphogenclamp((id_source_p==1), polariser_i) = 1;
            m.morphogenclamp((id_sink_p==1), polariser_i) = 1;
            P(id_sinus_p >0.03) = 0.45; % IUSED TO BE > 0.1 
            m.morphogenclamp((id_sinus_p==1), polariser_i) = 1;
            m = leaf_setpolfrozen (m, id_lip_p, false); % should freeze polarity on A side so it only reorients on the B side, this will be effcetive in the lip region
             
        case  'WT_criss-cross + sinus_A+B'%reorientation in both sides of the canvas
            
            id_sinus_p = (s_lat_p.^2) .* s_sink_p .* inh (100, id_hinge_p);
            
            m = leaf_mgen_conductivity( m, 'POLARISER', 0.0001 );  %specifies the diffusion rate of polariser
            m = leaf_mgen_absorption( m, 'POLARISER', 0.001 );     % specifies degradation rate of polariser
            P(id_source_p==1) = 1;
            P(id_sink_p==1) = 0.5;
            m.morphogenclamp((id_source_p==1), polariser_i) = 1;
            m.morphogenclamp((id_sink_p==1), polariser_i) = 1;
            P(id_sinus_p >0.03) = 0.1; % IUSED TO BE > 0.01 and  = 0.00001
            m.morphogenclamp((id_sinus_p==1), polariser_i) = 1;
            % m = leaf_setpolfrozen (m, id_lip_p, false); % should freeze polarity on A side so it only reorients on the B side, this will be effcetive in the lip region
            
    end
end

if(Steps(m)==14)
    switch modelname
        
        case  {'Figure 10A-F.   Phase I + II of wild-type wedge', 'WT_criss-cross + sinus_A+B', 'Figure 10J. No orthogonal directional conflict', 'Figure 10G. No surface conflict',...
                'Figure 10H. No areal conflict', 'WT_timing all at day 10'}
            
            m = leaf_mgen_conductivity( m, 'POLARISER', 0 );  %specifies the diffusion rate of polariser
            m = leaf_mgen_absorption( m, 'POLARISER', 0 );
    end
end

if (Steps(m)>6) %day 10
    % Code for specific models.
    switch modelname
                          
        case  {'Figure 9 A-F. Phase I + II of div domes', 'Figure 9I. No directional conflict and specified anisotropy'} %Adjusting the growth rates to the system use for the Antirrhinum model

            kbpar_p(:) = 0.02... % basic kpar growth rate
                .* inh (5, s_rad_p)... % keeps the hinge region from growing in length
                .* pro (0.8, id_lipdistal_p); % grows the lip region in length
            
            kbper_p(:) = 0.005... % basic kper growth rate
                .* inh (3, s_rad_p); % keeps hinge narrow
            
            kapar_p(:) = kbpar_p...
                .* inh (0.5, (s_rim_p>0.4).* inh (100, s_rad_p));% promotes furrow formation
            
            kaper_p(:) = kbper_p;
            
            knor_p(:)  = 0.0044;  % growth in canvas thickness
            
            v_kaniso_p = log( kbpar_p./kbper_p); % visualise growth anisotropy in ln scale
            v_karea_p = kbper_p + kbpar_p; % visualise areal growth rate
            
            if (Steps(m)>11)%morphogenetic repatterning at day 12
                
                id_brim_p (:) = s_rim_p > 0.01; %set region of brim dependent of the gradient of rim
                
                kbpar_p(:) = 0.012... % basic kpar growth rate 
                    .* inh (5, s_rad_p .* pro (3, id_lip_p))... % continuation of inh in hinge promoted speciafically in the lip to precente curling
                    .* pro (0.8, id_lipdistal_p)...% continuation of lip growth 
                    .* inh (2, s_rim_p)... % keeping the kpar low in the horizontal arms
                    .* pro (0.8, s_lat_p .* id_brim_p );... % create the vertical arms of crosses 
                    
                kbper_p(:) = 0.012 ... % basic kper growth rate  IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (3, s_rad_p)...% keeps hinge narrow
                    .* pro (2.5, s_rim_p)... % creating the horizontal arms in div and WT
                    .* inh (3, s_lat_p)...% keeping the kper low in the vertical arms
                    .* inh (3, s_med_p); % keep the midvein region regions narrow %INCREASED FROM 2
                
                kapar_p(:) = kbpar_p ...
                    .* inh (0.5, (s_rim_p>0.4).* inh (100, s_rad_p));% promotes furrow formation
                
                kaper_p(:) = kbper_p;
                knor_p(:)  = 0.0044;  % growth in canvas thickness
                v_kaniso_p = log( kbpar_p./kbper_p);% visualise growth anisotropy in ln scale
                v_karea_p = kbper_p + kbpar_p;% visualise areal growth rate

            end
            
            case  'Figure 9J. No orthogonal conflict'
            
           
            kbpar_p(:) = 0.02... % basic kpar growth rate
                .* inh (5, s_rad_p)... % keeps the hinge region from growing in length particularly in the lip region
                .* pro (0.8, id_lipdistal_p); % grows the lip region in length
            
            kbper_p(:) = 0.005... % basic kper growth rate
                .* inh (3, s_rad_p); % keeps hinge narrow
            
            kapar_p(:) = kbpar_p...
                .* inh (0.5, (s_rim_p>0.4).* inh (100, s_rad_p));% promotes furrow formation
            
            kaper_p(:) = kbper_p;
            
            knor_p(:)  = 0.0044;  % growth in canvas thickness
            
            v_kaniso_p = log( kbpar_p./kbper_p); % visualise growth anisotropy in ln scale
            v_karea_p = kbper_p + kbpar_p; % visualise areal growth rate
            
            
            if (Steps(m)>11) %morphogenetic repatterning at day 12
                
                kbpar_p(:) = 0.012... % basic kpar growth rate IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (5, s_rad_p .* pro (3, id_lip_p))... % continuation of inh in hinge promoted speciafically in the lip to precente curling
                    .* pro (0.8, id_lipdistal_p)...
                    ....* inh (2, s_rim_p)...
                    ....* pro (0.8, s_lat_p .* id_brim_p );% continuation of lip growth in length
                
                kbper_p(:) = 0.012 ... % basic kper growth rate  IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (3, s_rad_p)...% keeps hinge narrow
                    ....* pro (2.5, s_rim_p)... % creating the horizontal arms in div and WT
                    ....* inh (3, s_lat_p)...    
                    .* inh (3, s_med_p); % keep the midvein region regions narrow
                
                kapar_p(:) = kbpar_p ...
                     .* inh (0.5, (s_rim_p>0.4).* inh (100, s_rad_p));% promotes furrow formation
                
                kaper_p(:) = kbper_p;
                
                knor_p(:)  = 0.0044;  % growth in canvas thickness
                
                v_kaniso_p = log( kbpar_p./kbper_p);% visualise growth anisotropy in ln scale
                v_karea_p = kbper_p + kbpar_p;% visualise areal growth rate
                
            end

           case  'Figure 9G. No surface conflict' %Adjusting the growth rates to the system use for the Antirrhinum model

            kbpar_p(:) = 0.02... % basic kpar growth rate
                .* inh (5, s_rad_p)... % keeps the hinge region from growing in length
                .* pro (0.8, id_lipdistal_p); % grows the lip region in length
            
            kbper_p(:) = 0.005... % basic kper growth rate
                .* inh (3, s_rad_p); % keeps hinge narrow
            
            kapar_p(:) = kbpar_p...
                ... .* inh (0.5, (s_rim_p>0.4).* inh (100, s_rad_p));% promotes furrow formation
            
            kaper_p(:) = kbper_p;
            
            knor_p(:)  = 0.0044;  % growth in canvas thickness
            
            v_kaniso_p = log( kbpar_p./kbper_p); % visualise growth anisotropy in ln scale
            v_karea_p = kbper_p + kbpar_p; % visualise areal growth rate
            
            if (Steps(m)>11)%morphogenetic repatterning at day 12
                
                id_brim_p (:) = s_rim_p > 0.01; %set region of brim dependent of the gradient of rim
                
                kbpar_p(:) = 0.012... % basic kpar growth rate 
                    .* inh (5, s_rad_p .* pro (3, id_lip_p))... % continuation of inh in hinge promoted speciafically in the lip to precente curling
                    .* pro (0.8, id_lipdistal_p)...% continuation of lip growth 
                    .* inh (2, s_rim_p)... % keeping the kpar low in the horizontal arms
                    .* pro (0.8, s_lat_p .* id_brim_p );... % create the vertical arms of crosses 
                    
                kbper_p(:) = 0.012 ... % basic kper growth rate  IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (3, s_rad_p)...% keeps hinge narrow
                    .* pro (2.5, s_rim_p)... % creating the horizontal arms in div and WT
                    .* inh (3, s_lat_p)...% keeping the kper low in the vertical arms
                    .* inh (3, s_med_p); % keep the midvein region regions narrow %INCREASED FROM 2
                
                kapar_p(:) = kbpar_p ...
                    ... .* inh (0.5, (s_rim_p>0.4).* inh (100, s_rad_p));% promotes furrow formation
                
                kaper_p(:) = kbper_p;
                knor_p(:)  = 0.0044;  % growth in canvas thickness
                v_kaniso_p = log( kbpar_p./kbper_p);% visualise growth anisotropy in ln scale
                v_karea_p = kbper_p + kbpar_p;% visualise areal growth rate

            end
             case 'Figure 9H. No areal conflict'%Adjusting the growth rates to the system use for the Antirrhinum model

            kbpar_p(:) = 0.02... % basic kpar growth rate
                .* inh (5, s_rad_p)... % keeps the hinge region from growing in length
                .* pro (0.8, id_lipdistal_p); % grows the lip region in length
            
            kbper_p(:) = 0.005... % basic kper growth rate
                .* inh (3, s_rad_p); % keeps hinge narrow
            
            kapar_p(:) = kbpar_p...
                 .* inh (0.5, (s_rim_p>0.4).* inh (100, s_rad_p));% promotes furrow formation
            
            kaper_p(:) = kbper_p;
            
            knor_p(:)  = 0.0044;  % growth in canvas thickness
            
            v_kaniso_p = log( kbpar_p./kbper_p); % visualise growth anisotropy in ln scale
            v_kareab_p = kbper_p + kbpar_p; % visualise areal growth rate
            v_kareaa_p = kaper_p + kapar_p;
            kbpar_p (:) = 0.025*kbpar_p./v_kareab_p;
            kapar_p (:) = 0.025*kapar_p./v_kareaa_p;
            kbper_p (:) = 0.025*kbper_p./v_kareab_p;
            kaper_p (:) = 0.025*kaper_p./v_kareaa_p;
            v_kareab_p = kbper_p + kbpar_p; % visualise areal growth rate
            v_kareaa_p = kaper_p + kapar_p;
            v_kaniso_p = log( kbpar_p./kbper_p); % visualise growth anisotropy in ln scale
            
            if (Steps(m)>11)%morphogenetic repatterning at day 12
                
                id_brim_p (:) = s_rim_p > 0.01; %set region of brim dependent of the gradient of rim
                
                kbpar_p(:) = 0.012... % basic kpar growth rate
                    .* inh (5, s_rad_p .* pro (3, id_lip_p))... % continuation of inh in hinge promoted speciafically in the lip to precente curling
                    .* pro (0.8, id_lipdistal_p)...% continuation of lip growth
                    .* inh (2, s_rim_p)... % keeping the kpar low in the horizontal arms
                    .* pro (0.8, s_lat_p .* id_brim_p );... % create the vertical arms of crosses
                    
                kbper_p(:) = 0.012 ... % basic kper growth rate  IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (3, s_rad_p)...% keeps hinge narrow
                    .* pro (2.5, s_rim_p)... % creating the horizontal arms in div and WT
                    .* inh (3, s_lat_p )...% keeping the kper low in the vertical arms
                    .* inh (3, s_med_p); % keep the midvein region regions narrow %INCREASED FROM 2
                
                kapar_p(:) = kbpar_p ...
                    .* inh (0.5, (s_rim_p>0.4).* inh (100, s_rad_p));% promotes furrow formation
                
                kaper_p(:) = kbper_p;
                knor_p(:)  = 0.0044;  % growth in canvas thickness
                v_kaniso_p = log( kbpar_p./kbper_p); % visualise growth anisotropy in ln scale
                v_kareab_p = kbper_p + kbpar_p; % visualise areal growth rate
                v_kareaa_p = kaper_p + kapar_p;
                kbpar_p (:) = 0.025*kbpar_p./v_kareab_p;
                kapar_p (:) = 0.025*kapar_p./v_kareaa_p;
                kbper_p (:) = 0.025*kbper_p./v_kareab_p;
                kaper_p (:) = 0.025*kaper_p./v_kareaa_p;
                v_kareab_p = kbper_p + kbpar_p; % visualise areal growth rate
                v_kareaa_p = kaper_p + kapar_p;
                v_kaniso_p = log( kbpar_p./kbper_p); % visualise growth anisotropy in ln scale
                
            end
            
        case  'WT_criss-cross' %Adjusting the growth rates to the system use for the Antirrhinum model
            
            kbpar_p(:) = 0.02... % basic kpar growth rate
                .* inh (5, s_rad_p)... % keeps the hinge region from growing in length
                .* pro (0.8, id_lipdistal_p ).... % grows the lip region in length
                .* pro (1.5, s_div_p .* id_lipcliff_p)... %grows proximal lip region in length, important to create the region where the perpendicular growth that form the cheeks will happen
                .* pro (0.8, s_div_p .* id_palate_p .* pro (0.3, id_palateprox_p).* inh (5, id_source_p)); % DIV dependent growth in WT palate
            
            kbper_p(:) = 0.005... % basic kper growth rate
                .* inh (3, s_rad_p); % keeps hinge narrow
            
            kapar_p(:) = kbpar_p...
                .* inh (3, s_div_p .* s_rim_p .* inh (10, s_med_p) .* inh (100, s_rad_p)); %promotes furrow formation in WT by extending the asymetry between A and B with s_rim
            
            kaper_p(:) = kbper_p;
            
            knor_p(:)  = 0.0044;  % @@ Eqn xx
            
            v_kaniso_p = log( kbpar_p./kbper_p); % visualise growth anisotropy in ln scale
            v_karea_p = kbper_p + kbpar_p; % visualise areal growth rate
            
            if (Steps(m)>11)
                
                id_brim_p (:) = s_rim_p > 0.01;
                
                kbpar_p(:) = 0.012... % basic kpar growth rate IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (5, s_rad_p .* pro (3, id_lip_p))... % continuation of inh in hinge promoted specifically in the lip to prevente curling of the edges of the wedge
                    .* pro (0.8, id_lipdistal_p)...% continuation of lip growth
                    .* pro (0.5, s_div_p .* id_lipcliff_p)...%reduction if lipcliff growth upon the morphogenetic repatterning
                    .* pro (0.8, s_div_p .* id_palate_p .* pro (0.3, id_palateprox_p).* inh (5, id_source_p))...% continuation of DIV dependent growth in WT palate
                    .* inh (2, s_rim_p)... % keeping the kpar low in the horizontal arms
                    .* inh (0.2, (s_div_p >0.95) .* s_med_p .*id_brim_p)...% makes cleft in the ventral lip
                    .* inh (50, s_rad_p .*id_lipdistal_p.*inh (100, id_hinge_p))...%reduces parallel growth at the edge of the lip to make a triangular cheek
                    .* pro (0.8, s_lat_p .* id_brim_p); % create the vertical arm of crosses in div and WT
                
                kbper_p(:) = 0.012 ... % basic kper growth rate  IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (3, s_rad_p )...% keeps hinge narrow
                    .* pro (2.5,  s_rim_p .* pro (0.5, s_div_p))... % creating the horizontal arms in div and promoted in WT by DIV
                    .* inh (3, s_lat_p .* inh (1, (s_div_p>0.83).*id_lipcliff_p))...% keeping the kper low in the vertical arms
                    .* inh (0.5, (s_div_p >0.95) .* pro (1, 4*s_rim_p + 1.5*id_lipdistal_p).* inh (100, id_palateprox_p))... % keeps the WT ventral petal narrow and prevents the formation of two big peaks at the foci such as the Div het
                    .* inh (3, s_med_p .* inh (10,id_palate_p .*s_div_p))... % keep the midvein region regions narrow
                    .* inh (2, (1-s_div_p) .* id_lipdistal_p .*pro (2, id_sink_p).*inh (100, id_hinge_p))...% prevents fanning of the lip region in WT by keeping the upper edge of the lip lower in Kper   
                    .* pro (4.8, s_div_p .* id_lip_p.*s_secvein_p .*inh (8, s_rim_p)); % extends the horizontal arms to the proximal lip region
                
                kapar_p(:) = kbpar_p ...
                    .* inh (3, s_div_p .*s_rim_p .* inh (10, s_med_p) .* inh (100, s_rad_p));% promotes furrow formation in WT by extending the asymetry between A and B with s_rim
                
                kaper_p(:) = kbper_p...
                    .* inh (0.5, (s_div_p >0.95) .*id_lip_p); % makes ventral cheeks pop out
                
                v_kaniso_p = log( kbpar_p./kbper_p);
                v_karea_p = kbper_p + kbpar_p;
                
            end
            
            
        case  {'Figure 10A-F.   Phase I + II of wild-type wedge', 'Figure 10I. No directional conflict'}  %Adjusting the growth rates to the system use for the Antirrhinum model

            % palate length along junction = 14 mm
            % lip length along the junction = 10 mm
            % palate width at bottom = 15 mm
            % palate width at bottom of wedge = 8.5 mm
            % width of lip at ventral petal = 6.5 mm
            % width of lip at lateral petal = 10 mm
            kbpar_p(:) = 0.02... % basic kpar growth rate
                .* inh (5, s_rad_p)... % keeps the hinge region from growing in length
                .* pro (0.8, id_lipdistal_p ).... % grows the lip region in length
                .* pro (1.5, s_div_p .* id_lipcliff_p)... %grows proximal lip region in length, important to create the region where the perpendicular growth that form the cheeks will happen
                .* pro (0.8, s_div_p .* id_palate_p .* pro (0.3, id_palateprox_p).* inh (5, id_source_p)); % DIV dependent growth in WT palate
            
            kbper_p(:) = 0.005... % basic kper growth rate
                .* inh (3, s_rad_p); % keeps hinge narrow
            
            kapar_p(:) = kbpar_p...
                .* inh (3, s_div_p .* s_rim_p .* inh (10, s_med_p) .* inh (100, s_rad_p)); %promotes furrow formation in WT by extending the asymetry between A and B with s_rim
            
            kaper_p(:) = kbper_p;
            
            knor_p(:)  = 0.0044;  % @@ Eqn xx
            
            v_kaniso_p = log( kbpar_p./kbper_p); % visualise growth anisotropy in ln scale
            v_karea_p = kbper_p + kbpar_p; % visualise areal growth rate
            
            if (Steps(m)>11)
                
                id_brim_p (:) = s_rim_p > 0.01;
                
                kbpar_p(:) = 0.012... % basic kpar growth rate IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (5, s_rad_p .* pro (3, id_lip_p))... % continuation of inh in hinge promoted specifically in the lip to prevente curling of the edges of the wedge
                    .* pro (0.8, id_lipdistal_p)...% continuation of lip growth
                    .* pro (0.5, s_div_p .* id_lipcliff_p)...%reduction if lipcliff growth upon the morphogenetic repatterning
                    .* pro (0.8, s_div_p .* id_palate_p .* pro (0.3, id_palateprox_p).* inh (5, id_source_p))...% continuation of DIV dependent growth in WT palate
                    .* inh (2, s_rim_p)... % keeping the kpar low in the horizontal arms
                    .* inh (0.2, (s_div_p >0.95) .* s_med_p .*id_brim_p)...% makes cleft in the ventral lip
                    .* inh (50, s_rad_p .*id_lipdistal_p.*inh (100, id_hinge_p))...%reduces parallel growth at the edge of the lip to make a triangular cheek
                    .* pro (0.8, s_lat_p .* id_brim_p); % create the vertical arm of crosses in div and WT
                
                kbper_p(:) = 0.012 ... % basic kper growth rate  IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (3, s_rad_p )...% keeps hinge narrow
                    .* pro (2.5,  s_rim_p .* pro (0.5, s_div_p))... % creating the horizontal arms in div and promoted in WT by DIV
                    .* inh (3, s_lat_p .* inh (1, (s_div_p>0.83).*id_lipcliff_p))...% keeping the kper low in the vertical arms
                    .* inh (0.5, (s_div_p >0.95) .* pro (1, 4*s_rim_p + 1.5*id_lipdistal_p).* inh (100, id_palateprox_p))... % keeps the WT ventral petal narrow and prevents the formation of two big peaks at the foci such as the Div het
                    .* inh (3, s_med_p .* inh (10,id_palate_p .*s_div_p))... % keep the midvein region regions narrow
                    .* inh (2, (1-s_div_p) .* id_lipdistal_p .*pro (2, id_sink_p).*inh (100, id_hinge_p))...% prevents fanning of the lip region in WT by keeping the upper edge of the lip lower in Kper   
                    .* pro (4.8, s_div_p .* id_lip_p.*s_secvein_p .*inh (8, s_rim_p)); % extends the horizontal arms to the proximal lip region
                
                kapar_p(:) = kbpar_p ...
                    .* inh (3, s_div_p .*s_rim_p .* inh (10, s_med_p) .* inh (100, s_rad_p));% promotes furrow formation in WT by extending the asymetry between A and B with s_rim
                
                kaper_p(:) = kbper_p...
                    .* inh (0.5, (s_div_p >0.95) .*id_lip_p); % makes ventral cheeks pop out
                
                v_kaniso_p = log( kbpar_p./kbper_p);
                v_karea_p = kbper_p + kbpar_p;
                
            end
            
             case  {'Figure 10J. No orthogonal directional conflict'}  %Adjusting the growth rates to the system use for the Antirrhinum model

            % palate length along junction = 14 mm
            % lip length along the junction = 10 mm
            % palate width at bottom = 15 mm
            % palate width at bottom of wedge = 8.5 mm
            % width of lip at ventral petal = 6.5 mm
            % width of lip at lateral petal = 10 mm
            kbpar_p(:) = 0.02... % basic kpar growth rate
                .* inh (5, s_rad_p)... % keeps the hinge region from growing in length
                .* pro (0.8, id_lipdistal_p ).... % grows the lip region in length
                .* pro (1.5, s_div_p .* id_lipcliff_p)... %grows proximal lip region in length, important to create the region where the perpendicular growth that form the cheeks will happen
                .* pro (0.8, s_div_p .* id_palate_p .* pro (0.3, id_palateprox_p).* inh (5, id_source_p)); % DIV dependent growth in WT palate
            
            kbper_p(:) = 0.005... % basic kper growth rate
                .* inh (3, s_rad_p); % keeps hinge narrow
            
            kapar_p(:) = kbpar_p...
                .* inh (3, s_div_p .* s_rim_p .* inh (10, s_med_p) .* inh (100, s_rad_p)); %promotes furrow formation in WT by extending the asymetry between A and B with s_rim
            
            kaper_p(:) = kbper_p;
            
            knor_p(:)  = 0.0044;  % @@ Eqn xx
            
            v_kaniso_p = log( kbpar_p./kbper_p); % visualise growth anisotropy in ln scale
            v_karea_p = kbper_p + kbpar_p; % visualise areal growth rate
            
            if (Steps(m)>11)
                
                id_brim_p (:) = s_rim_p > 0.01;
                
                kbpar_p(:) = 0.012... % basic kpar growth rate IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (5, s_rad_p .* pro (3, id_lip_p))... % continuation of inh in hinge promoted specifically in the lip to prevente curling of the edges of the wedge
                    .* pro (0.8, id_lipdistal_p)...% continuation of lip growth
                    .* pro (0.5, s_div_p .* id_lipcliff_p)...%reduction if lipcliff growth upon the morphogenetic repatterning
                    .* pro (0.8, s_div_p .* id_palate_p .* pro (0.3, id_palateprox_p).* inh (5, id_source_p))...% continuation of DIV dependent growth in WT palate
                    ...* inh (2, s_rim_p)... % keeping the kpar low in the horizontal arms
                    .* inh (0.2, (s_div_p >0.95) .* s_med_p .*id_brim_p)...% makes cleft in the ventral lip
                    .* inh (50, s_rad_p .*id_lipdistal_p.*inh (100, id_hinge_p))...%reduces parallel growth at the edge of the lip to make a triangular cheek
                    ....* pro (0.8, s_lat_p .* id_brim_p); % create the vertical arm of crosses in div and WT
                
                kbper_p(:) = 0.012 ... % basic kper growth rate  IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (3, s_rad_p )...% keeps hinge narrow
                    ....* pro (2.5,  s_rim_p .* pro (0.5, s_div_p))... % creating the horizontal arms in div and promoted in WT by DIV
                    ....* inh (3, s_lat_p .* inh (1, (s_div_p>0.83).*id_lipcliff_p))...% keeping the kper low in the vertical arms
                    .* inh (0.5, (s_div_p >0.95) .* pro (1, 4*s_rim_p + 1.5*id_lipdistal_p).* inh (100, id_palateprox_p))... % keeps the WT ventral petal narrow and prevents the formation of two big peaks at the foci such as the Div het
                    .* inh (3, s_med_p .* inh (10,id_palate_p .*s_div_p))... % keep the midvein region regions narrow
                    .* inh (2, (1-s_div_p) .* id_lipdistal_p .*pro (2, id_sink_p).*inh (100, id_hinge_p))...% prevents fanning of the lip region in WT by keeping the upper edge of the lip lower in Kper   
                    ....* pro (4.8, s_div_p .* id_lip_p.*s_secvein_p .*inh (8, s_rim_p)); % extends the horizontal arms to the proximal lip region
                
                kapar_p(:) = kbpar_p ...
                    .* inh (3, s_div_p .*s_rim_p .* inh (10, s_med_p) .* inh (100, s_rad_p));% promotes furrow formation in WT by extending the asymetry between A and B with s_rim
                
                kaper_p(:) = kbper_p...
                    .* inh (0.5, (s_div_p >0.95) .*id_lip_p); % makes ventral cheeks pop out
                
                v_kaniso_p = log( kbpar_p./kbper_p);
                v_karea_p = kbper_p + kbpar_p;
                
            end
            
            
        case  'WT_criss-cross + sinus_A+B' %Adjusting the growth rates to the system use for the Antirrhinum model
            
            % palate length along junction = 14 mm
            % lip length along the junction = 10 mm
            % palate width at bottom = 15 mm
            % palate width at bottom of wedge = 8.5 mm
            % width of lip at ventral petal = 6.5 mm
            % width of lip at lateral petal = 10 mm
            
            kbpar_p(:) = 0.02... % basic kpar growth rate
                .* inh (5, s_rad_p)... % keeps the hinge region from growing in length
                .* pro (0.8, id_lipdistal_p ).... % grows the lip region in length
                .* pro (1.5, s_div_p .* id_lipcliff_p)... %grows proximal lip region in length, important to create the region where the perpendicular growth that form the cheeks will happen
                .* pro (0.8, s_div_p .* id_palate_p .* pro (0.3, id_palateprox_p).* inh (5, id_source_p)); % DIV dependent growth in WT palate
            
            kbper_p(:) = 0.005... % basic kper growth rate
                .* inh (3, s_rad_p); % keeps hinge narrow
            
            kapar_p(:) = kbpar_p...
                .* inh (3, s_div_p .* s_rim_p .* inh (10, s_med_p) .* inh (100, s_rad_p)); %promotes furrow formation in WT by extending the asymetry between A and B with s_rim
            
            kaper_p(:) = kbper_p;
            
            knor_p(:)  = 0.0044;  % @@ Eqn xx
            
            v_kaniso_p = log( kbpar_p./kbper_p); % visualise growth anisotropy in ln scale
            v_karea_p = kbper_p + kbpar_p; % visualise areal growth rate
            
            if (Steps(m)>11)
                
                id_brim_p (:) = s_rim_p > 0.01;
                
                kbpar_p(:) = 0.012... % basic kpar growth rate IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (5, s_rad_p .* pro (3, id_lip_p))... % continuation of inh in hinge promoted specifically in the lip to prevente curling of the edges of the wedge
                    .* pro (0.8, id_lipdistal_p)...% continuation of lip growth
                    .* pro (0.5, s_div_p .* id_lipcliff_p)...%reduction if lipcliff growth upon the morphogenetic repatterning
                    .* pro (0.8, s_div_p .* id_palate_p .* pro (0.3, id_palateprox_p).* inh (5, id_source_p))...% continuation of DIV dependent growth in WT palate
                    .* inh (2, s_rim_p)... % keeping the kpar low in the horizontal arms
                    .* inh (0.2, (s_div_p >0.95) .* s_med_p .*id_brim_p)...% makes cleft in the ventral lip
                    .* inh (50, s_rad_p .*id_lipdistal_p.*inh (100, id_hinge_p))...%reduces parallel growth at the edge of the lip to make a triangular cheek
                    .* pro (0.8, s_lat_p .* id_brim_p); % create the vertical arm of crosses in div and WT
                
                kbper_p(:) = 0.012 ... % basic kper growth rate  IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (3, s_rad_p )...% keeps hinge narrow
                    .* pro (2.5,  s_rim_p .* pro (0.5, s_div_p))... % creating the horizontal arms in div and promoted in WT by DIV
                    .* inh (3, s_lat_p .* inh (1, (s_div_p>0.83).*id_lipcliff_p))...% keeping the kper low in the vertical arms
                    .* inh (0.5, (s_div_p >0.95) .* pro (1, 4*s_rim_p + 1.5*id_lipdistal_p).* inh (100, id_palateprox_p))... % keeps the WT ventral petal narrow and prevents the formation of two big peaks at the foci such as the Div het
                    .* inh (3, s_med_p .* inh (10,id_palate_p .*s_div_p))... % keep the midvein region regions narrow
                    .* inh (2, (1-s_div_p) .* id_lipdistal_p .*pro (2, id_sink_p).*inh (100, id_hinge_p))...% prevents fanning of the lip region in WT by keeping the upper edge of the lip lower in Kper   
                    .* pro (4.8, s_div_p .* id_lip_p.*s_secvein_p .*inh (8, s_rim_p)); % extends the horizontal arms to the proximal lip region
                
                kapar_p(:) = kbpar_p ...
                    .* inh (3, s_div_p .*s_rim_p .* inh (10, s_med_p) .* inh (100, s_rad_p));% promotes furrow formation in WT by extending the asymetry between A and B with s_rim
                
                kaper_p(:) = kbper_p...
                    .* inh (0.5, (s_div_p >0.95) .*id_lip_p); % makes ventral cheeks pop out
                
                v_kaniso_p = log( kbpar_p./kbper_p);
                v_karea_p = kbper_p + kbpar_p;
                
            end
            
        case  {'Figure 10G. No surface conflict'}  %Adjusting the growth rates to the system use for the Antirrhinum model

            % palate length along junction = 14 mm
            % lip length along the junction = 10 mm
            % palate width at bottom = 15 mm
            % palate width at bottom of wedge = 8.5 mm
            % width of lip at ventral petal = 6.5 mm
            % width of lip at lateral petal = 10 mm
            kbpar_p(:) = 0.02... % basic kpar growth rate
                .* inh (5, s_rad_p)... % keeps the hinge region from growing in length
                .* pro (0.8, id_lipdistal_p ).... % grows the lip region in length
                .* pro (1.5, s_div_p .* id_lipcliff_p)... %grows proximal lip region in length, important to create the region where the perpendicular growth that form the cheeks will happen
                .* pro (0.8, s_div_p .* id_palate_p .* pro (0.3, id_palateprox_p).* inh (5, id_source_p)); % DIV dependent growth in WT palate
            
            kbper_p(:) = 0.005... % basic kper growth rate
                .* inh (3, s_rad_p); % keeps hinge narrow
            
            kapar_p(:) = kbpar_p;...
               ... .* inh (3, s_div_p .* s_rim_p .* inh (10, s_med_p) .* inh (100, s_rad_p)); %promotes furrow formation in WT by extending the asymetry between A and B with s_rim
            
            kaper_p(:) = kbper_p;
            
            knor_p(:)  = 0.0044;  % @@ Eqn xx
            
            v_kaniso_p = log( kbpar_p./kbper_p); % visualise growth anisotropy in ln scale
            v_karea_p = kbper_p + kbpar_p; % visualise areal growth rate
            
            if (Steps(m)>11)
                
                id_brim_p (:) = s_rim_p > 0.01;
                
                kbpar_p(:) = 0.012... % basic kpar growth rate IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (5, s_rad_p .* pro (3, id_lip_p))... % continuation of inh in hinge promoted specifically in the lip to prevente curling of the edges of the wedge
                    .* pro (0.8, id_lipdistal_p)...% continuation of lip growth
                    .* pro (0.5, s_div_p .* id_lipcliff_p)...%reduction if lipcliff growth upon the morphogenetic repatterning
                    .* pro (0.8, s_div_p .* id_palate_p .* pro (0.3, id_palateprox_p).* inh (5, id_source_p))...% continuation of DIV dependent growth in WT palate
                    .* inh (2, s_rim_p)... % keeping the kpar low in the horizontal arms
                    .* inh (0.2, (s_div_p >0.95) .* s_med_p .*id_brim_p)...% makes cleft in the ventral lip
                    .* inh (50, s_rad_p .*id_lipdistal_p.*inh (100, id_hinge_p))...%reduces parallel growth at the edge of the lip to make a triangular cheek
                    .* pro (0.8, s_lat_p .* id_brim_p); % create the vertical arm of crosses in div and WT
                
                kbper_p(:) = 0.012 ... % basic kper growth rate  IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (3, s_rad_p )...% keeps hinge narrow
                    .* pro (2.5,  s_rim_p .* pro (0.5, s_div_p))... % creating the horizontal arms in div and promoted in WT by DIV
                    .* inh (3, s_lat_p .* inh (1, (s_div_p>0.83).*id_lipcliff_p))...% keeping the kper low in the vertical arms
                    .* inh (0.5, (s_div_p >0.95) .* pro (1, 4*s_rim_p + 1.5*id_lipdistal_p).* inh (100, id_palateprox_p))... % keeps the WT ventral petal narrow and prevents the formation of two big peaks at the foci such as the Div het
                    .* inh (3, s_med_p .* inh (10,id_palate_p .*s_div_p))... % keep the midvein region regions narrow
                    .* inh (2, (1-s_div_p) .* id_lipdistal_p .*pro (2, id_sink_p).*inh (100, id_hinge_p))...% prevents fanning of the lip region in WT by keeping the upper edge of the lip lower in Kper   
                    .* pro (4.8, s_div_p .* id_lip_p.*s_secvein_p .*inh (8, s_rim_p)); % extends the horizontal arms to the proximal lip region
                
                kapar_p(:) = kbpar_p; ...
                    ....* inh (3, s_div_p .*s_rim_p .* inh (10, s_med_p) .* inh (100, s_rad_p));% promotes furrow formation in WT by extending the asymetry between A and B with s_rim
                
                kaper_p(:) = kbper_p;...
                    ....* inh (0.5, (s_div_p >0.95) .*id_lip_p); % makes ventral cheeks pop out
                
                v_kaniso_p = log( kbpar_p./kbper_p);
                v_karea_p = kbper_p + kbpar_p;
                
            end
           case  {'Figure 10H. No areal conflict'}  %Adjusting the growth rates to the system use for the Antirrhinum model

            % palate length along junction = 14 mm
            % lip length along the junction = 10 mm
            % palate width at bottom = 15 mm
            % palate width at bottom of wedge = 8.5 mm
            % width of lip at ventral petal = 6.5 mm
            % width of lip at lateral petal = 10 mm
            kbpar_p(:) = 0.02... % basic kpar growth rate
                .* inh (5, s_rad_p)... % keeps the hinge region from growing in length
                .* pro (0.8, id_lipdistal_p ).... % grows the lip region in length
                .* pro (1.5, s_div_p .* id_lipcliff_p)... %grows proximal lip region in length, important to create the region where the perpendicular growth that form the cheeks will happen
                .* pro (0.8, s_div_p .* id_palate_p .* pro (0.3, id_palateprox_p).* inh (5, id_source_p)); % DIV dependent growth in WT palate
            
            kbper_p(:) = 0.005... % basic kper growth rate
                .* inh (3, s_rad_p); % keeps hinge narrow
            
            kapar_p(:) = kbpar_p...
               .* inh (3, s_div_p .* s_rim_p .* inh (10, s_med_p) .* inh (100, s_rad_p)); %promotes furrow formation in WT by extending the asymetry between A and B with s_rim
            
            kaper_p(:) = kbper_p;
            
            knor_p(:)  = 0.0044;  % @@ Eqn xx
            
            v_kaniso_p = log( kbpar_p./kbper_p); % visualise growth anisotropy in ln scale
            v_kareab_p = kbper_p + kbpar_p; % visualise areal growth rate
            v_kareaa_p = kaper_p + kapar_p;
            kbpar_p (:) = 0.025*kbpar_p./v_kareab_p;
            kapar_p (:) = 0.025*kapar_p./v_kareaa_p;
            kbper_p (:) = 0.025*kbper_p./v_kareab_p;
            kaper_p (:) = 0.025*kaper_p./v_kareaa_p;
            v_kareab_p = kbper_p + kbpar_p; % visualise areal growth rate
            v_kareaa_p = kaper_p + kapar_p;
            v_kaniso_p = log( kbpar_p./kbper_p); % visualise growth anisotropy in ln scale
            
            if (Steps(m)>11)
                
                id_brim_p (:) = s_rim_p > 0.01;
                
                kbpar_p(:) = 0.012... % basic kpar growth rate IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (5, s_rad_p .* pro (3, id_lip_p))... % continuation of inh in hinge promoted specifically in the lip to prevente curling of the edges of the wedge
                    .* pro (0.8, id_lipdistal_p)...% continuation of lip growth
                    .* pro (0.5, s_div_p .* id_lipcliff_p)...%reduction if lipcliff growth upon the morphogenetic repatterning
                    .* pro (0.8, s_div_p .* id_palate_p .* pro (0.3, id_palateprox_p).* inh (5, id_source_p))...% continuation of DIV dependent growth in WT palate
                    .* inh (2, s_rim_p)... % keeping the kpar low in the horizontal arms
                    .* inh (0.2, (s_div_p >0.95) .* s_med_p .*id_brim_p)...% makes cleft in the ventral lip
                    .* inh (50, s_rad_p .*id_lipdistal_p.*inh (100, id_hinge_p))...%reduces parallel growth at the edge of the lip to make a triangular cheek
                    .* pro (0.8, s_lat_p .* id_brim_p); % create the vertical arm of crosses in div and WT
                
                kbper_p(:) = 0.012 ... % basic kper growth rate  IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (3, s_rad_p )...% keeps hinge narrow
                    .* pro (2.5,  s_rim_p .* pro (0.5, s_div_p))... % creating the horizontal arms in div and promoted in WT by DIV
                    .* inh (3, s_lat_p .* inh (1, (s_div_p>0.83).*id_lipcliff_p))...% keeping the kper low in the vertical arms
                    .* inh (0.5, (s_div_p >0.95) .* pro (1, 4*s_rim_p + 1.5*id_lipdistal_p).* inh (100, id_palateprox_p))... % keeps the WT ventral petal narrow and prevents the formation of two big peaks at the foci such as the Div het
                    .* inh (3, s_med_p .* inh (10,id_palate_p .*s_div_p))... % keep the midvein region regions narrow
                    .* inh (2, (1-s_div_p) .* id_lipdistal_p .*pro (2, id_sink_p).*inh (100, id_hinge_p))...% prevents fanning of the lip region in WT by keeping the upper edge of the lip lower in Kper   
                    .* pro (4.8, s_div_p .* id_lip_p.*s_secvein_p .*inh (8, s_rim_p)); % extends the horizontal arms to the proximal lip region
                
                kapar_p(:) = kbpar_p ...
                    .* inh (3, s_div_p .*s_rim_p .* inh (10, s_med_p) .* inh (100, s_rad_p));% promotes furrow formation in WT by extending the asymetry between A and B with s_rim
                
                kaper_p(:) = kbper_p...
                    .* inh (0.5, (s_div_p >0.95) .*id_lip_p); % makes ventral cheeks pop out
                
            v_kaniso_p = log( kbpar_p./kbper_p); % visualise growth anisotropy in ln scale
            v_kareab_p = kbper_p + kbpar_p; % visualise areal growth rate
            v_kareaa_p = kaper_p + kapar_p;
            kbpar_p (:) = 0.025*kbpar_p./v_kareab_p;
            kapar_p (:) = 0.025*kapar_p./v_kareaa_p;
            kbper_p (:) = 0.025*kbper_p./v_kareab_p;
            kaper_p (:) = 0.025*kaper_p./v_kareaa_p;
            v_kareab_p = kbper_p + kbpar_p; % visualise areal growth rate
            v_kareaa_p = kaper_p + kapar_p;
            v_kaniso_p = log( kbpar_p./kbper_p); % visualise growth anisotropy in ln scale
            
                
            end 
            
          case  {'WT_timing all at day 10'}  %Adjusting the growth rates to the system use for the Antirrhinum model

            % palate length along junction = 14 mm
            % lip length along the junction = 10 mm
            % palate width at bottom = 15 mm
            % palate width at bottom of wedge = 8.5 mm
            % width of lip at ventral petal = 6.5 mm
            % width of lip at lateral petal = 10 mm
            kbpar_p(:) = 0.02... % basic kpar growth rate
                .* inh (5, s_rad_p)... % keeps the hinge region from growing in length
                .* pro (0.8, id_lipdistal_p ).... % grows the lip region in length
                ....* pro (1.5, s_div_p .* id_lipcliff_p)... %grows proximal lip region in length, important to create the region where the perpendicular growth that form the cheeks will happen
                ....* pro (0.8, s_div_p .* id_palate_p .* pro (0.3, id_palateprox_p).* inh (5, id_source_p)); % DIV dependent growth in WT palate
            
            kbper_p(:) = 0.005... % basic kper growth rate
                .* inh (3, s_rad_p); % keeps hinge narrow
            
            kapar_p(:) = kbpar_p...
                ....* inh (3, s_div_p .* s_rim_p .* inh (10, s_med_p) .* inh (100, s_rad_p)); %promotes furrow formation in WT by extending the asymetry between A and B with s_rim
            
            kaper_p(:) = kbper_p;
            
            knor_p(:)  = 0.0044;  % @@ Eqn xx
            
            v_kaniso_p = log( kbpar_p./kbper_p); % visualise growth anisotropy in ln scale
            v_karea_p = kbper_p + kbpar_p; % visualise areal growth rate
            
            if (Steps(m)>11)
                
                id_brim_p (:) = s_rim_p > 0.01;
                
                kbpar_p(:) = 0.012... % basic kpar growth rate IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (5, s_rad_p .* pro (3, id_lip_p))... % continuation of inh in hinge promoted specifically in the lip to prevente curling of the edges of the wedge
                    .* pro (0.8, id_lipdistal_p)...% continuation of lip growth
                    .* pro (0.5, s_div_p .* id_lipcliff_p)...%reduction if lipcliff growth upon the morphogenetic repatterning
                    .* pro (0.8, s_div_p .* id_palate_p .* pro (0.3, id_palateprox_p).* inh (5, id_source_p))...% continuation of DIV dependent growth in WT palate
                    .* inh (2, s_rim_p)... % keeping the kpar low in the horizontal arms
                    .* inh (0.2, (s_div_p >0.95) .* s_med_p .*id_brim_p)...% makes cleft in the ventral lip
                    .* inh (50, s_rad_p .*id_lipdistal_p.*inh (100, id_hinge_p))...%reduces parallel growth at the edge of the lip to make a triangular cheek
                    .* pro (0.8, s_lat_p .* id_brim_p); % create the vertical arm of crosses in div and WT
                
                kbper_p(:) = 0.012 ... % basic kper growth rate  IDEALLY NOT LATE DEPENDENT USED TO BE 0.1
                    .* inh (3, s_rad_p )...% keeps hinge narrow
                    .* pro (2.5,  s_rim_p .* pro (0.5, s_div_p))... % creating the horizontal arms in div and promoted in WT by DIV
                    .* inh (3, s_lat_p .* inh (1, (s_div_p>0.83).*id_lipcliff_p))...% keeping the kper low in the vertical arms
                    .* inh (0.5, (s_div_p >0.95) .* pro (1, 4*s_rim_p + 1.5*id_lipdistal_p).* inh (100, id_palateprox_p))... % keeps the WT ventral petal narrow and prevents the formation of two big peaks at the foci such as the Div het
                    .* inh (3, s_med_p .* inh (10,id_palate_p .*s_div_p))... % keep the midvein region regions narrow
                    .* inh (2, (1-s_div_p) .* id_lipdistal_p .*pro (2, id_sink_p).*inh (100, id_hinge_p))...% prevents fanning of the lip region in WT by keeping the upper edge of the lip lower in Kper   
                    .* pro (4.8, s_div_p .* id_lip_p.*s_secvein_p .*inh (8, s_rim_p)); % extends the horizontal arms to the proximal lip region
                
                kapar_p(:) = kbpar_p ...
                    .* inh (3, s_div_p .*s_rim_p .* inh (10, s_med_p) .* inh (100, s_rad_p));% promotes furrow formation in WT by extending the asymetry between A and B with s_rim
                
                kaper_p(:) = kbper_p...
                    .* inh (0.5, (s_div_p >0.95) .*id_lip_p); % makes ventral cheeks pop out
                
                v_kaniso_p = log( kbpar_p./kbper_p);
                v_karea_p = kbper_p + kbpar_p;
                
            end
            
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
    m.morphogens(:,id_med_i) = id_med_p;
    m.morphogens(:,id_junction_i) = id_junction_p;
    m.morphogens(:,id_rim_i) = id_rim_p;
    m.morphogens(:,s_source_i) = s_source_p;
    m.morphogens(:,s_rim_i) = s_rim_p;
    m.morphogens(:,s_med_i) = s_med_p;
    m.morphogens(:,s_lat_i) = s_lat_p;
    m.morphogens(:,v_flower_i) = v_flower_p;
    m.morphogens(:,id_spotty_i) = id_spotty_p;
    m.morphogens(:,id_stripy_i) = id_stripy_p;
    m.morphogens(:,id_late_i) = id_late_p;
    m.morphogens(:,id_sinus_i) = id_sinus_p;
    m.morphogens(:,s_sinus_i) = s_sinus_p;
    m.morphogens(:,s_sink_i) = s_sink_p;
    m.morphogens(:,id_lipcliff_i) = id_lipcliff_p;
    m.morphogens(:,v_speckareal_i) = v_speckareal_p;
    m.morphogens(:,v_specaniso_i) = v_specaniso_p;
    m.morphogens(:,id_early_i) = id_early_p;
    m.morphogens(:,id_palate_i) = id_palate_p;
    m.morphogens(:,id_hinge_i) = id_hinge_p;
    m.morphogens(:,id_ventmidvein_i) = id_ventmidvein_p;
    m.morphogens(:,id_secvein_i) = id_secvein_p;
    m.morphogens(:,s_ventmidvein_i) = s_ventmidvein_p;
    m.morphogens(:,s_secvein_i) = s_secvein_p;
    m.morphogens(:,id_div_i) = id_div_p;
    m.morphogens(:,s_div_i) = s_div_p;
    m.morphogens(:,id_lat_i) = id_lat_p;
    m.morphogens(:,v_kaniso_i) = v_kaniso_p;
    m.morphogens(:,id_lipbend_i) = id_lipbend_p;
    m.morphogens(:,id_tube_i) = id_tube_p;
    m.morphogens(:,id_rad_i) = id_rad_p;
    m.morphogens(:,s_rad_i) = s_rad_p;
    m.morphogens(:,id_lipdistal_i) = id_lipdistal_p;
    m.morphogens(:,id_lip_i) = id_lip_p;
    m.morphogens(:,id_twinpeaks_i) = id_twinpeaks_p;
    m.morphogens(:,id_cheeks_i) = id_cheeks_p;
    m.morphogens(:,id_foci_i) = id_foci_p;
    m.morphogens(:,s_foci_i) = s_foci_p;
    m.morphogens(:,id_dorsaledge_i) = id_dorsaledge_p;
    m.morphogens(:,s_dorsaledge_i) = s_dorsaledge_p;
    m.morphogens(:,v_diff_i) = v_diff_p;
    m.morphogens(:,id_lobe_i) = id_lobe_p;
    m.morphogens(:,id_subdivision_i) = id_subdivision_p;
    m.morphogens(:,s_hinge_i) = s_hinge_p;
    m.morphogens(:,id_time_i) = id_time_p;
    m.morphogens(:,glate_i) = glate_p;
    m.morphogens(:,id_fixvertex_i) = id_fixvertex_p;
    m.morphogens(:,id_palateprox_i) = id_palateprox_p;
    m.morphogens(:,id_brim_i) = id_brim_p;
    m.morphogens(:,id_pltdistal_i) = id_pltdistal_p;
    m.morphogens(:,v_karea_i) = v_karea_p;
    m.morphogens(:,id_palatedi_i) = id_palatedi_p;
    m.morphogens(:,v_kareaa_i) = v_kareaa_p;
    m.morphogens(:,v_kareab_i) = v_kareab_p;

%%% USER CODE: FINALISATION

% In this section you may modify the mesh in any way whatsoever.

% If needed force FE to subdivide (increase number FE's) here
% if (Steps(m)==5)
% m = leaf_subdivide( m, 'morphogen','id_subdivision',...
%       'min',0.2,'max',1,...
%       'mode','mid','levels','all');
% end

% if (Steps(m)==4)
% m = leaf_subdivide( m, 'morphogen','id_lipcliff',...
%       'min',0.5,'max',1,...
%       'mode','mid','levels','all');
% end
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
