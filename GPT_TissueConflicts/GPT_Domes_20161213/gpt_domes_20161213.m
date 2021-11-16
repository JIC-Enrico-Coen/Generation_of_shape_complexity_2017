function m = gpt_domes_20161213( m )
%m = gpt_domes_20161213( m )
%   Morphogen interaction function.
%   Written at 2016-12-13 16:33:20.
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
m=leaf_plotoptions(m,'layeroffset', 0.2);    % set colour of polariser gradient arrows
m=leaf_plotoptions(m,'highgradcolor',[0,0,0],'lowgradcolor',[0,0,0]);
m=leaf_plotoptions(m,'decorscale',1.5);
m=leaf_plotoptions(m,'arrowthickness',1.3);
m=leaf_plotoptions(m,'sidegrad','AB'); %polariser gradient will be plotted on both sides

if (Steps(m)==0) && m.globalDynamicProps.doinit % First iteration
    
    % Set up names for variant models.  
    
    m.userdata.ranges.modelname.range {1} = 'Figure 1A, B. Uniform isotropic growth';
    m.userdata.ranges.modelname.range {2} = 'Figure 1C, D. Uniform anisotropic growth';
    m.userdata.ranges.modelname.range {3} = 'Figure 1E, F.  Surface conflict'; 
    m.userdata.ranges.modelname.range {4} = 'Figure 1G, H. Areal conflict'; 
    m.userdata.ranges.modelname.range {5} = 'Figure 1I, J. Convergent directional conflict';
    m.userdata.ranges.modelname.range {6} = 'Figure 1 Sup 1 A, B. Areal conflict flat start'; 
    m.userdata.ranges.modelname.range {7} = 'Figure 1 Sup 1 C, D. Convergent directional conflict flat start';     
    m.userdata.ranges.modelname.range {8} = 'Figure 6F, G. Orthogonal directional conflict'; 
    m.userdata.ranges.modelname.range {9} = 'Figure 6H, I.  T-shaped directional conflict'; 
    m.userdata.ranges.modelname.range {10} = 'Figure 6J, K.  L-shaped directional conflict';
    m.userdata.ranges.modelname.range {11} = 'Figure 6L, M. Directional conflict for vertical domain';
    m.userdata.ranges.modelname.range {12} = 'Figure 6N, O. Directional conflict for upper half of vertical domain';
    m.userdata.ranges.modelname.range {13} = 'Figure 6P, Q. Orthogonal directional conflict in a parallel polarity field';
    m.userdata.ranges.modelname.range {14} = 'Figure 6R, S Orthogonal areal conflict';
    m.userdata.ranges.modelname.range {15} = 'Figure 6T, U. Orthogonal directional conflict in an orthogonal polarity field';
    m.userdata.ranges.modelname.range {16} = 'Figure 6_supplement 1A, B.  Combining directional and areal conflicts';
    m.userdata.ranges.modelname.range {17} = 'Figure 6_supplement 1C.  Combining surface and directional conflicts';
    m.userdata.ranges.modelname.range {18} = 'Figure 6_supplement 1D.  Combining surface and areal conflicts';    
    m.userdata.ranges.modelname.range {19} = 'Figure 7A, B.  Surface conflict without overall growth';
    m.userdata.ranges.modelname.range {20} = 'Figure 7C, D.  Areal conflict without overall growth';    
    m.userdata.ranges.modelname.range {21} = 'Figure 7E, F. Convergent directional conflict without overall growth';    
    m.userdata.ranges.modelname.range {22} = 'Figure 7G, H.  Orthogonal directional conflict in a parallel polarity field without overall growth';    
    m.userdata.ranges.modelname.index =18;                      
    
    
    m = leaf_bowlz(m, 0.01 ); %induce a slightly curve in the medio-lateral axis of the canvas
    m = leaf_setthickness(m, 0.06); %thickness of canvas, relates to the 60 um of the real data
    
    % set colour of polariser gradient arrows
    m=leaf_plotoptions(m,'highgradcolor',[0,0,0],'lowgradcolor',[0,0,0]);
    m=leaf_plotoptions(m,'decorscale',1.5);
    m=leaf_plotoptions(m,'arrowthickness',1.5);
    
    m.globalProps.timestep=1; %each step relates to 10 hours in real time
    
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
    [s_jun_i,s_jun_p,s_jun_a,s_jun_l] = getMgenLevels( m, 'S_JUN' );
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
    [s_edge_i,s_edge_p,s_edge_a,s_edge_l] = getMgenLevels( m, 'S_EDGE' );
    [id_centre_i,id_centre_p,id_centre_a,id_centre_l] = getMgenLevels( m, 'ID_CENTRE' );
    [s_focicentre_i,s_focicentre_p,s_focicentre_a,s_focicentre_l] = getMgenLevels( m, 'S_FOCICENTRE' );
    [s_fociflanks_i,s_fociflanks_p,s_fociflanks_a,s_fociflanks_l] = getMgenLevels( m, 'S_FOCIFLANKS' );
    [id_ring_i,id_ring_p,id_ring_a,id_ring_l] = getMgenLevels( m, 'ID_RING' );
    [id_foo_i,id_foo_p,id_foo_a,id_foo_l] = getMgenLevels( m, 'ID_FOO' );
    [id_radial_i,id_radial_p,id_radial_a,id_radial_l] = getMgenLevels( m, 'ID_RADIAL' );
    [id_flan_i,id_flan_p,id_flan_a,id_flan_l] = getMgenLevels( m, 'ID_FLAN' );
    [v_karea_i,v_karea_p,v_karea_a,v_karea_l] = getMgenLevels( m, 'V_KAREA' );
    [s_flan_i,s_flan_p,s_flan_a,s_flan_l] = getMgenLevels( m, 'S_FLAN' );
    [id_lower_i,id_lower_p,id_lower_a,id_lower_l] = getMgenLevels( m, 'ID_LOWER' );
    [id_diagonal_i,id_diagonal_p,id_diagonal_a,id_diagonal_l] = getMgenLevels( m, 'ID_DIAGONAL' );
    [id_floorbasal_i,id_floorbasal_p,id_floorbasal_a,id_floorbasal_l] = getMgenLevels( m, 'ID_FLOORBASAL' );
    [id_floorlateral_i,id_floorlateral_p,id_floorlateral_a,id_floorlateral_l] = getMgenLevels( m, 'ID_FLOORLATERAL' );
    [s_floorbasal_i,s_floorbasal_p,s_floorbasal_a,s_floorbasal_l] = getMgenLevels( m, 'S_FLOORBASAL' );
    [s_floorlateral_i,s_floorlateral_p,s_floorlateral_a,s_floorlateral_l] = getMgenLevels( m, 'S_FLOORLATERAL' );
    [v_kareab_i,v_kareab_p,v_kareab_a,v_kareab_l] = getMgenLevels( m, 'V_KAREAB' );
    [id_top_i,id_top_p,id_top_a,id_top_l] = getMgenLevels( m, 'ID_TOP' );
    [id_side_i,id_side_p,id_side_a,id_side_l] = getMgenLevels( m, 'ID_SIDE' );
    [id_distalhalf_i,id_distalhalf_p,id_distalhalf_a,id_distalhalf_l] = getMgenLevels( m, 'ID_DISTALHALF' );
    [id_leftside_i,id_leftside_p,id_leftside_a,id_leftside_l] = getMgenLevels( m, 'ID_LEFTSIDE' );
    [id_sides_i,id_sides_p,id_sides_a,id_sides_l] = getMgenLevels( m, 'ID_SIDES' );
    [id_halfside_i,id_halfside_p,id_halfside_a,id_halfside_l] = getMgenLevels( m, 'ID_HALFSIDE' );

% Mesh type: rectangle
%            base: 0
%          centre: 0
%          layers: 0
%      randomness: 0.001
%       thickness: 0
%           xdivs: 40
%          xwidth: 1
%           ydivs: 40
%          ywidth: 1

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
%               ID_MED         ----    ----       ----     ----
%          ID_JUNCTION         ----    ----       ----     ----
%               ID_RIM         ----    ----       ----     ----
%             S_SOURCE         ----    ----       ----     ----
%                S_RIM         ----    ----       ----     ----
%                S_MED         ----    ----       ----     ----
%                S_JUN         ----    ----       ----     ----
%             V_FLOWER         ----    ----       ----     ----
%            ID_SPOTTY         ----    ----       ----     ----
%            ID_STRIPY         ----    ----       ----     ----
%              ID_LATE         ----    ----       ----     ----
%             ID_SINUS         ----    ----       ----     ----
%              S_SINUS         ----    ----       ----     ----
%               S_SINK         0.01     0.1       ----     ----
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
%               S_FOCI         ----    ----       ----     ----
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
%               S_EDGE         ----    ----       ----     ----
%            ID_CENTRE         ----    ----       ----     ----
%         S_FOCICENTRE         ----    ----       ----     ----
%         S_FOCIFLANKS         ----    ----       ----     ----
%              ID_RING         ----    ----       ----     ----
%               ID_FOO         ----    ----       ----     ----
%            ID_RADIAL         ----    ----       ----     ----
%              ID_FLAN         ----    ----       ----     ----
%              V_KAREA         ----    ----       ----     ----
%               S_FLAN         ----    ----       ----     ----
%             ID_LOWER         ----    ----       ----     ----
%          ID_DIAGONAL         ----    ----       ----     ----
%        ID_FLOORBASAL         ----    ----       ----     ----
%      ID_FLOORLATERAL         ----    ----       ----     ----
%         S_FLOORBASAL         ----   0.001       ----     ----
%       S_FLOORLATERAL         ----   0.001       ----     ----
%             V_KAREAB         ----    ----       ----     ----
%               ID_TOP         ----    ----       ----     ----
%              ID_SIDE         ----    ----       ----     ----
%        ID_DISTALHALF         ----    ----       ----     ----
%          ID_LEFTSIDE         ----    ----       ----     ----
%             ID_SIDES         ----    ----       ----     ----
%          ID_HALFSIDE         ----    ----       ----     ----


%%% USER CODE: MORPHOGEN INTERACTIONS

% In this section you may modify the mesh in any way that does not
% alter the set of nodes.


if (Steps(m)==0) && m.globalDynamicProps.doinit  % Initialisation code.
    
    %check to see if we need a non bowlz canvas
    switch modelname        
        case{'Figure 1 Sup 1 A, B. Areal conflict flat start' , 'Figure 1 Sup 1 C, D. Convergent directional conflict flat start', 'Figure 6_supplement 1D.  Combining surface and areal conflicts' }
            %set the canvas to be flat
            m = leaf_setzeroz( m );
            m = leaf_perturbz( m, 0.001, 'absolute', false ); 
    end
    
    %set up initial morphogens
    switch modelname
                
        case {'Figure 1G, H. Areal conflict', 'Figure 1 Sup 1 A, B. Areal conflict flat start', 'Figure 7C, D.  Areal conflict without overall growth', 'Figure 6_supplement 1D.  Combining surface and areal conflicts'}
            
            rsq = sum( m.nodes.^2, 2 ); % Calculates the square of the radius of every vertex
            
            %id_centre
            id_centre_p (:) = 0;
            id_centre_p =exp( -rsq/0.3.^2 );
            
            %id_edge
            id_edge_p (:) = 0;
            id_edge_p = 1-id_centre_p; % find the vetex at the edge of the canvas with the max radius values
            
        case {'Figure 1I, J. Convergent directional conflict', 'Figure 1 Sup 1 C, D. Convergent directional conflict flat start',...
              'Figure 7E, F. Convergent directional conflict without overall growth', 'Figure 6F, G. Orthogonal directional conflict', ...
              'Figure 6L, M. Directional conflict for vertical domain',...
              'Figure 6H, I.  T-shaped directional conflict', 'Figure 6J, K.  L-shaped directional conflict',...
              'Figure 6N, O. Directional conflict for upper half of vertical domain', 'Figure 6_supplement 1C.  Combining surface and directional conflicts'}
            
            %PRN - Setting convergence polarity field at the centre of the canvas
            rsq = sum( m.nodes.^2, 2 ); % Calculates the square of the radius of every vertex
            id_edge_p = rsq/max(rsq); % find the vertex at the edge of the canvas with the max radius values
            P(id_edge_p>0.4)=1; %production of polariser at the edge of canvas
            P(id_foci_p==1)=0.1; %degradation of polariser at the centre of the canvas
            m.morphogenclamp((id_foci_p==1)|(id_edge_p==1),polariser_i) = 1;%stable polariser gradient by clamping the production and degradation of the polariser
            m = leaf_mgen_conductivity( m, 'POLARISER', 0.0005 );  %specifies the diffusion rate of polariser
            m = leaf_mgen_absorption( m, 'POLARISER', 0.005 ); % specifies degradation rate of polariser
            
            %GRN - Setting the identity and signalling factors that control the growth rates
            %ID_RIM
            id_rim_p (:) = 0;
            id_rim_p(m.nodes(:,2) < 0.01 & m.nodes(:,2) > - 0.01) = 1;
            
            %ID_JUNCTION
            id_junction_p (:) = 0;
            id_junction_p(m.nodes(:,1) < 0.01 & m.nodes(:,1) > - 0.01) = 1;
            
            %id_foci
            id_foci_p (:) = 0;
            id_foci_p = id_rim_p .* id_junction_p;
            
            %S_RIM
            s_rim_p(:) = 0;
            s_rim_p(:) = 5*id_rim_p;
            m = leaf_mgen_conductivity( m, 'S_RIM', 0.001 );
            m = leaf_mgen_absorption( m, 'S_RIM', 0.01 );
            
            %S_JUN
            s_jun_p(:) = 0;
            s_jun_p(:) = 5*id_junction_p;
            m = leaf_mgen_conductivity( m, 'S_JUN', 0.001 );
            m = leaf_mgen_absorption( m, 'S_JUN', 0.01 );
            
            %S_FOCI
            s_foci_p (:) = 0;
            s_foci_p (:) = 10*id_foci_p;
            m = leaf_mgen_conductivity( m, 'S_FOCI', 0.0005);
            m = leaf_mgen_absorption( m, 'S_FOCI', 0.005);
            
            rsq = sum( m.nodes.^2, 2 ); % Calculates the square of the radius of every vertex
            %id_centre
            id_centre_p (:) = 0;
            id_centre_p =exp( -rsq/0.3.^2 );
            
            %id_halfside
            id_halfside_p (:) = 0;
            id_halfside_p(m.nodes(:,1) < 0) = 1;
            
            %id_distalhalf
            id_distalhalf_p(:)=0;
            id_distalhalf_p (m.nodes(:,2) > 0)=1;
            
            
        case {'Figure 6P, Q. Orthogonal directional conflict in a parallel polarity field',...
              'Figure 1C, D. Uniform anisotropic growth'...
              'Figure 7G, H.  Orthogonal directional conflict in a parallel polarity field without overall growth',...
              'Figure 6_supplement 1A, B.  Combining directional and areal conflicts'}
            
            %PRN - Setting convergence polarity field at the centre of the canvas
            bottom = m.nodes(:,2) == min(m.nodes(:,2)); %find the bottom nodes
            top = m.nodes(:,2)== max(m.nodes(:,2)); %find the top nodes
            id_sink_p(top) = 1; %activate expression of sink at the top nodes
            id_source_p(bottom) = 1;%activate expression of source at the bottom nodes
            P(bottom) = 1;%source of polariser at the bottom of canvas
            P(top) = 0.01;%sink of polariser at the top of the canvas
            m.morphogenclamp(bottom, polariser_i) = 1;%stable polariser gradient by clamping the production of the polariser
            m.morphogenclamp(top, polariser_i) = 1;%stable polariser gradient by clamping the degradation of the polariser
            m = leaf_mgen_conductivity( m, 'POLARISER', 0.01 );  %specifies the diffusion rate of polariser
            m = leaf_mgen_absorption( m, 'POLARISER', 0.1 );     % specifies degradation rate of polariser
            
            %GRN - Setting the identity and signalling factors that control the growth rates
            %ID_RIM
            id_rim_p (:) = 0;
            id_rim_p(m.nodes(:,2) < 0.01 & m.nodes(:,2) > - 0.01) = 1;
            
            %S_RIM
            s_rim_p(:) = 0;
            s_rim_p(:) = 5*id_rim_p;
            m = leaf_mgen_conductivity( m, 'S_RIM', 0.001 );
            m = leaf_mgen_absorption( m, 'S_RIM', 0.01 );
            
            %ID_JUNCTION
            id_junction_p(m.nodes(:,1) < 0.01 & m.nodes(:,1) > - 0.01) = 1;
            
            %S_JUN
            s_jun_p(:) = 0;
            s_jun_p(:) = 5*id_junction_p;
            m = leaf_mgen_conductivity( m, 'S_JUN', 0.001 );
            m = leaf_mgen_absorption( m, 'S_JUN', 0.01 );
            
            
        case {'Figure 6R, S Orthogonal areal conflict'}
            
            %             %PRN - Setting convergence polarity field at the centre of the canvas
            %             bottom = m.nodes(:,2) == min(m.nodes(:,2)); %find the bottom nodes
            %             top = m.nodes(:,2)== max(m.nodes(:,2)); %find the top nodes
            %             id_sink_p(top) = 1; %activate expression of sink at the top nodes
            %             id_source_p(bottom) = 1;%activate expression of source at the bottom nodes
            %             P(bottom) = 1;%production of polariser at the bottom of canvas
            %             P(top) = 0.01;%degradation of polariser at the top of the canvas
            %             m.morphogenclamp(bottom, polariser_i) = 1;%stable polariser gradient by clamping the production of the polariser
            %             m.morphogenclamp(top, polariser_i) = 1;%stable polariser gradient by clamping the degradation of the polariser
            %             m = leaf_mgen_conductivity( m, 'POLARISER', 0.01 );  %specifies the diffusion rate of polariser
            %             m = leaf_mgen_absorption( m, 'POLARISER', 0.1 );     % specifies degradation rate of polariser
            %
            %GRN - Setting the identity and signalling factors that control the growth rates
            %ID_RIM
            id_rim_p (:) = 0;
            id_rim_p(m.nodes(:,2) < 0.01 & m.nodes(:,2) > - 0.01) = 1;
            
            %S_RIM
            s_rim_p(:) = 0;
            s_rim_p(:) = 5*id_rim_p;
            m = leaf_mgen_conductivity( m, 'S_RIM', 0.001 );
            m = leaf_mgen_absorption( m, 'S_RIM', 0.01 );
            
            %ID_JUNCTION
            id_junction_p(m.nodes(:,1) < 0.01 & m.nodes(:,1) > - 0.01) = 1;
            
            %S_JUN
            s_jun_p(:) = 0;
            s_jun_p(:) = 5*id_junction_p;
            m = leaf_mgen_conductivity( m, 'S_JUN', 0.001 );
            m = leaf_mgen_absorption( m, 'S_JUN', 0.01 );
            
            
        case 'Figure 6T, U. Orthogonal directional conflict in an orthogonal polarity field'
            
            %PRN - Setting convergence polarity field at the centre of the canvas
            %ID_TOP
            id_top_p(m.nodes(:,2) > 0.45 ) = 1;
            
            %ID_SOURCE
            id_source_p(m.nodes(:,2) < - 0.45)= 1;
            
            %ID_side
            id_side_p(m.nodes(:,1) < - 0.45) =1;
            id_side_p(m.nodes(:,1) > 0.45) = 1;
            
            %ID_JUNCTION
            id_junction_p(m.nodes(:,1) < 0.01 & m.nodes(:,1) > - 0.01) = 1;
            
            %ID_SINK
            id_sink_p (:) = 0;
            id_sink_p = id_top_p .* id_junction_p;
            
            m = leaf_mgen_conductivity( m, 'POLARISER', 0.01 );  %specifies the diffusion rate of polariser
            m = leaf_mgen_absorption( m, 'POLARISER', 0.1 );     % specifies degradation rate of polariser
            P(:) = 0.1;%basal polariser production
            P(id_source_p ==1) = 0.1;%production of polariser at the bottom of canvas
            P(id_sink_p==1) = 0.01;%degradation of polariser at the centre of the top nodes of canvas
            m.morphogenclamp((id_source_p==1), polariser_i) = 1;%stable polariser gradient by clamping the production of the polariser
            m.morphogenclamp((id_sink_p==1), polariser_i) = 1;%stable polariser gradient by clamping the degradation of the polariser
            
            %GRN - Setting the identity and signalling factors that control the growth rates
            %ID_RIM
            id_rim_p (:) = 0;
            id_rim_p(m.nodes(:,2) < 0.01 & m.nodes(:,2) > - 0.01) = 1;
            
            %S_RIM
            s_rim_p(:) = 0;
            s_rim_p(:) = 5*id_rim_p;
            m = leaf_mgen_conductivity( m, 'S_RIM', 0.001 );
            m = leaf_mgen_absorption( m, 'S_RIM', 0.01 );
            
            %S_JUN
            s_jun_p(:) = 0;
            s_jun_p(:) = 5*id_junction_p;
            m = leaf_mgen_conductivity( m, 'S_JUN', 0.001 );
            m = leaf_mgen_absorption( m, 'S_JUN', 0.01 );
            
            %S_SINK
            s_sink_p(:) = 0;
            s_sink_p(:) = 20*id_sink_p;
            m = leaf_mgen_conductivity( m, 'S_SINK', 0.01 );
            m = leaf_mgen_absorption( m, 'S_SINK', 0.1 );
            
            %id_foci
            id_foci_p (:) = 0;
            id_foci_p = id_rim_p .* id_junction_p;
            
            %S_FOCI
            s_foci_p (:) = 0;
            s_foci_p (:) = 10*id_foci_p;
            m = leaf_mgen_conductivity( m, 'S_FOCI', 0.0005);
            m = leaf_mgen_absorption( m, 'S_FOCI', 0.005);
            
            
            
    end
    
end
if (Steps(m)==3) && m.globalDynamicProps.doinit  % Initialisation code.
    
    switch modelname
        
        case 'Figure 6T, U. Orthogonal directional conflict in an orthogonal polarity field'
            
            m = leaf_mgen_conductivity( m, 'POLARISER', 0.01 );  %specifies the diffusion rate of polariser
            m = leaf_mgen_absorption( m, 'POLARISER', 0.1 );     % specifies degradation rate of polariser
            
            id_junction_p = s_jun_p;
            %id_side_p = id_side_p .* inh (100, id_sink_p);
            
            m.morphogenclamp((id_source_p==1), polariser_i) = 0;%stable polariser gradient by clamping the production of the polariser
            m.morphogenclamp((id_sink_p==1), polariser_i) = 0;%stable polariser gradient by clamping the degradation of the polariser
            m.morphogenclamp((id_junction_p > 0.2), polariser_i) = 1;%stable polariser gradient by clamping the degradation of the polariser
            P(id_side_p ==1) = 1;%production of polariser at the side of teh channel
            m.morphogenclamp((id_side_p==1), polariser_i) = 1;%stable polariser gradient by clamping the production of the polariser
            
            %id_margins
            id_margins_p (:) = 0;
            id_margins_p = s_jun_p <0.18;
            
    end
end

if(Steps(m)==5)
    %sets all diffusible factors to 0 freezing their gradients
    m = leaf_mgen_conductivity( m, 'POLARISER', 0 );
    m = leaf_mgen_absorption( m, 'POLARISER', 0 );
    m = leaf_mgen_conductivity( m, 'S_JUN', 0 );
    m = leaf_mgen_absorption( m, 'S_JUN', 0 );
    m = leaf_mgen_conductivity( m, 'S_RIM', 0 );
    m = leaf_mgen_absorption( m, 'S_RIM', 0 );
    m = leaf_mgen_conductivity( m, 'S_FOCI', 0);
    m = leaf_mgen_absorption( m, 'S_FOCI', 0);
    
end

if(Steps(m)==6)
    %add clones
%     m = leaf_makesecondlayer( m, ...  % This function adds biological cells.
%         'mode', 'each', ...  % Make biological celrea was 1/16000 of the initial area of the flower.
%         'probpervx', 'V_FLOWER', ... % induce tranls randomly scattered over the flower.
%         'relarea', 1/900, ...   % Each cell has asposed cells over whole corolla
%         'numcells',500,...%number of cells (that will become clones)
%         'sides', 16, ...  % Each cell is approximated as a 6-sided regular polygon.
%         'colors', [0.5 0.5 0.5], ...  % Default colour is gray but
%         'allowoverlap', false, ...
%         'colorvariation',1,... % Each cell is a random colour
%         'add', true );  % These cells are added to any cells existing already
    m = leaf_plotoptions( m, 'cellbodyvalue', '' );
end

if (Steps(m)>6)
    % Code for specific models.
    
    switch modelname
        
        case 'Figure 1A, B. Uniform isotropic growth'
            kapar_p(:) = 0.03;
            kaper_p(:) = 0.03;
            kbpar_p(:) = kapar_p;
            kbper_p(:) = kaper_p;
            knor_p(:)  = 0.044;
            
            
        case {'Figure 1G, H. Areal conflict', 'Figure 1 Sup 1 A, B. Areal conflict flat start'}
            kbpar_p(:) = 0.05 + 0.05.*id_centre_p;%growth is boosted at the centre of the canvas
            kbper_p(:) = 0.05 + 0.05.*id_centre_p;%growth is boosted at the centre of the canvas
            kapar_p(:) = kbpar_p;
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.044;
            v_karea_p = kapar_p +kaper_p;
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
            
        case 'Figure 7C, D.  Areal conflict without overall growth'
            kbpar_p(:) = 0.019 -0.032.*id_edge_p; %contraction at the edge of the canvas
            kbper_p(:) = 0.019 -0.032.*id_edge_p; %contraction at the edge of the canvas
            kapar_p(:) = kbpar_p;
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0;
            v_karea_p = kapar_p +kaper_p;
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
        case 'Figure 1E, F.  Surface conflict'
            kbpar_p(:) = 0.05;
            kbper_p(:) = 0.05;
            kapar_p(:) = 0.06; %slightly more growth on the top surface
            kaper_p(:) = 0.06; %slightly more growth on the top surface
            knor_p(:)  = 0.044;
            v_karea_p = kapar_p +kaper_p;
            v_kareab_p = kbpar_p +kbper_p;
            m = leaf_plotoptions( m, 'morphogenA', 'v_karea', 'morphogenB', 'v_kareab' );
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
        case 'Figure 7A, B.  Surface conflict without overall growth'
            
            kbpar_p(:) = -0.005;%contraction of the lower surface
            kbper_p(:) = -0.005;%contraction of the lower surface
            kapar_p(:) = 0.005;
            kaper_p(:) = 0.005;
            knor_p(:)  = 0;
            v_karea_p = kapar_p +kaper_p;
            v_kareab_p = kbpar_p +kbper_p;
            m = leaf_plotoptions( m, 'morphogenA', 'v_karea', 'morphogenB', 'v_kareab' );
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
        case 'Figure 1C, D. Uniform anisotropic growth'
            
            kbpar_p(:) = 0.03;%growth is higher parallel to the polarity than perpendicular while also inhibited in Kpar at the center of the canvas where polarity converges
            kbper_p(:) = 0.02;%growth is higher parallel to the polarity than perpendicular while also normalise for the foci Kpar inhibition by the promotion in Kper at the foci (in that way Karea is uniform)
            kapar_p(:) = kbpar_p;
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.044;
            v_karea_p = kapar_p +kaper_p;
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
        case {'Figure 1I, J. Convergent directional conflict', 'Figure 1 Sup 1 C, D. Convergent directional conflict flat start'}
            
            kbpar_p(:) = 0.05;%growth is higher parallel to the polarity than perpendicular while also inhibited in Kpar at the center of the canvas where polarity converges
            kbper_p(:) = 0.02;%growth is higher parallel to the polarity than perpendicular while also normalise for the foci Kpar inhibition by the promotion in Kper at the foci (in that way Karea is uniform)
            kapar_p(:) = kbpar_p;
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.044;
            v_karea_p = kapar_p +kaper_p;
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
        case 'Figure 7E, F. Convergent directional conflict without overall growth'
            
            kbpar_p(:) = 0.01; % basal growth of canvas
            kbper_p(:) = -0.01; % contraction perpendicular to the polartity
            kapar_p(:) = kbpar_p;
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0;
            v_karea_p = kapar_p +kaper_p;
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
        case  'Figure 6F, G. Orthogonal directional conflict'
            
            kbpar_p(:) = 0.05 + 0.05*s_jun_p + 0.05*s_rim_p - 0.2*s_jun_p.*s_rim_p; %growth is boosted parallel to the polarity by sJUN and sRIM while also inhibited in Kpar at the center of the canvas where sJUN and sRIM intersect
            kbper_p(:) = 0.05 -0.05*s_rim_p -0.05*s_jun_p + 0.2*s_jun_p.*s_rim_p; %normalisation of Kpar boost with inhibition in Kper at sJUN and sRIM while boosting at intersection (uniform Karea)
            kapar_p(:) = kbpar_p;
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.044;
            v_karea_p = kapar_p +kaper_p;
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
        case 'Figure 6L, M. Directional conflict for vertical domain'
            
            kbpar_p(:) = 0.05 + 0.05*s_jun_p - 0.1*s_jun_p.*s_rim_p;%growth is boosted parallel to the polarity by sJUN while  inhibited in Kpar at the center of the canvas where sJUN and sRIM intersect
            kbper_p(:) = 0.05 -0.05*s_jun_p + 0.1*s_jun_p.*s_rim_p;%normalisation of Kpar boost with inhibition in Kper at sJUN while boosting at intersection (uniform Karea)
            kapar_p(:) = kbpar_p;
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.044;
            v_karea_p = kapar_p +kaper_p;
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
        case  'Figure 6H, I.  T-shaped directional conflict'
            
            kbpar_p(:) = 0.05 + 0.05*s_jun_p + 0.05*s_rim_p.*id_halfside_p - 0.1*s_jun_p.*s_rim_p;%growth is boosted parallel to the polarity by sJUN and sRIM, only on the letside of canvas, while also inhibited in Kpar at the center of the canvas where sJUN and sRIM intersect
            kbper_p(:) = 0.05 - 0.05*s_jun_p - 0.05*s_rim_p.*id_halfside_p + 0.1*s_jun_p.*s_rim_p;%normalisation of Kpar boost with inhibition in Kper while boosting at intersection (uniform Karea)             
            kapar_p(:) = kbpar_p;
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.044;
            v_karea_p = kapar_p +kaper_p;
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
        case  'Figure 6J, K.  L-shaped directional conflict'
            
            kbpar_p(:) = 0.05 + 0.05*s_jun_p.*id_distalhalf_p + 0.05*s_rim_p.*id_halfside_p - 0.02*s_jun_p.*s_rim_p ;%growth is boosted parallel to the polarity by sJUN, only at the distalhalf of the canvas, and sRIM, only on the letside of canvas, while also inhibited in Kpar at the center of the canvas where sJUN and sRIM intersect
            kbper_p(:) = 0.05 - 0.05*s_jun_p.*id_distalhalf_p - 0.05*s_rim_p.*id_halfside_p + 0.02*s_jun_p.*s_rim_p;%normalisation of Kpar boost with inhibition in Kper while boosting at intersection (uniform Karea)              
            kapar_p(:) = kbpar_p;
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.044;
            v_karea_p = kapar_p +kaper_p;
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
        case   'Figure 6N, O. Directional conflict for upper half of vertical domain'
            
            kbpar_p(:) = 0.05 + 0.05*s_jun_p.*id_distalhalf_p ;%growth is boosted parallel to the polarity by sJUN, only at the distalhalf of the canvas
            kbper_p(:) = 0.05  -0.05*s_jun_p.*id_distalhalf_p;%normalisation of Kpar boost with inhibition in Kper (uniform Karea)
            kapar_p(:) = kbpar_p;
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.044;
            v_karea_p = kapar_p +kaper_p;
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
        case  {'Figure 6P, Q. Orthogonal directional conflict in a parallel polarity field'}
            
            kbpar_p(:) = 0.05 + 0.05*s_jun_p - 0.05*s_rim_p; %growth is boosted parallel to the polarity by sJUN while inhibited by sRIM
            kbper_p(:) = 0.05 - 0.05*s_jun_p + 0.05*s_rim_p ;%growth is boosted perpendicular to the polarity by sRIM while inhibited by sJUN
            kapar_p(:) = kbpar_p;
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.044;
            v_karea_p = kapar_p +kaper_p;
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
        case {'Figure 6R, S Orthogonal areal conflict'}
            
            kbpar_p(:) = 0.05 + 0.05*s_jun_p + 0.05*s_rim_p - 0.2*s_jun_p.*s_rim_p; %growth is boosted parallel to the polarity by sJUN while inhibited by sRIM
            kbper_p(:) = 0.05 + 0.05*s_jun_p + 0.05*s_rim_p - 0.2*s_jun_p.*s_rim_p;%growth is boosted perpendicular to the polarity by sRIM while inhibited by sJUN
            kapar_p(:) = kbpar_p;
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.044;
            v_karea_p = kapar_p +kaper_p;
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
        case {'Figure 7G, H.  Orthogonal directional conflict in a parallel polarity field without overall growth'}
            
            kbpar_p(:) = 0.05*s_jun_p -0.05*s_rim_p; %growth is boosted parallel to the polarity by sJUN while counterbalance by contraction in sRIM
            kbper_p(:) = 0.05*s_rim_p -0.05*s_jun_p;%growth is boosted perpendicular to the polarity by sRIM while counterbalance by contraction in sJUN
            kapar_p(:) = kbpar_p;
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0;
            v_karea_p = kapar_p +kaper_p;
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
        case 'Figure 6T, U. Orthogonal directional conflict in an orthogonal polarity field'
            
            kbpar_p(:) = 0.05 + 0.05*s_jun_p + 0.05*s_rim_p.*id_margins_p - 0.075*s_jun_p.*s_rim_p;%growth is boosted parallel to the polarity by sJUN and sRIM, only at the margins, while also inhibited in Kpar at the center of the canvas where sJUN and sRIM intersect
            kbper_p(:) = 0.05 -0.05*s_rim_p.*id_margins_p -0.05*s_jun_p + 0.075*s_jun_p.*s_rim_p; %normalisation of Kpar boost with inhibition in Kper while boosting at intersection (uniform Karea)
            kapar_p(:) = kbpar_p;
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.044;
            v_karea_p = kapar_p +kaper_p;
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
        case  {'Figure 6_supplement 1A, B.  Combining directional and areal conflicts'}
            
            kbpar_p(:) = 0.01 + 0.06*s_jun_p - 0.12*s_jun_p.*s_rim_p; %growth is boosted parallel to the polarity by sJUN while inhibited by sRIM
            kbper_p(:) = 0.01 + 0.06*s_rim_p - 0.12*s_jun_p.*s_rim_p;%growth is boosted perpendicular to the polarity by sRIM while inhibited by sJUN
            kapar_p(:) = kbpar_p;
            kaper_p(:) = kbper_p;
            knor_p(:)  = 0.01;
            v_karea_p = kapar_p +kaper_p;
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
        case  'Figure 6_supplement 1D.  Combining surface and areal conflicts'
            
            kbpar_p(:) = 0.025 + 0.025.*id_centre_p;%growth is boosted at the centre of the canvas
            kbper_p(:) = 0.025 + 0.025.*id_centre_p;%growth is boosted at the centre of the canvas
            kapar_p(:) = 0.03 + 0.025.*id_centre_p;
            kaper_p(:) = 0.03 + 0.025.*id_centre_p;
            knor_p(:)  = 0.03;
            v_karea_p = kapar_p +kaper_p;
            v_kareab_p = kbpar_p +kbper_p;
            m = leaf_plotoptions( m, 'morphogenA', 'v_karea', 'morphogenB', 'v_kareab' );
            v_kaniso_p =  log (kbpar_p./kbper_p);
            
        case  'Figure 6_supplement 1C.  Combining surface and directional conflicts'
            
            kapar_p(:) = 0.055 + 0.05*s_jun_p + 0.05*s_rim_p - 0.2*s_jun_p.*s_rim_p;
            kaper_p(:) = 0.055 - 0.05*s_jun_p - 0.05*s_rim_p + 0.2*s_jun_p.*s_rim_p;
            kbpar_p(:) = 0.05 + 0.05*s_jun_p + 0.05*s_rim_p - 0.2*s_jun_p.*s_rim_p; %growth is boosted parallel to the polarity by sJUN and sRIM while also inhibited in Kpar at the center of the canvas where sJUN and sRIM intersect
            kbper_p(:) = 0.05 - 0.05*s_jun_p - 0.05*s_rim_p + 0.2*s_jun_p.*s_rim_p; %normalisation of Kpar boost with inhibition in Kper at sJUN and sRIM while boosting at intersection (uniform Karea)
            knor_p(:)  = 0.044;
            v_karea_p = kapar_p +kaper_p;
            v_kaniso_p =  log (kbpar_p./kbper_p);
            v_karea_p = kapar_p +kaper_p;
            v_kareab_p = kbpar_p +kbper_p;
            m = leaf_plotoptions( m, 'morphogenA', 'v_karea', 'morphogenB', 'v_kareab' );
            
            
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
    m.morphogens(:,s_jun_i) = s_jun_p;
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
    m.morphogens(:,s_edge_i) = s_edge_p;
    m.morphogens(:,id_centre_i) = id_centre_p;
    m.morphogens(:,s_focicentre_i) = s_focicentre_p;
    m.morphogens(:,s_fociflanks_i) = s_fociflanks_p;
    m.morphogens(:,id_ring_i) = id_ring_p;
    m.morphogens(:,id_foo_i) = id_foo_p;
    m.morphogens(:,id_radial_i) = id_radial_p;
    m.morphogens(:,id_flan_i) = id_flan_p;
    m.morphogens(:,v_karea_i) = v_karea_p;
    m.morphogens(:,s_flan_i) = s_flan_p;
    m.morphogens(:,id_lower_i) = id_lower_p;
    m.morphogens(:,id_diagonal_i) = id_diagonal_p;
    m.morphogens(:,id_floorbasal_i) = id_floorbasal_p;
    m.morphogens(:,id_floorlateral_i) = id_floorlateral_p;
    m.morphogens(:,s_floorbasal_i) = s_floorbasal_p;
    m.morphogens(:,s_floorlateral_i) = s_floorlateral_p;
    m.morphogens(:,v_kareab_i) = v_kareab_p;
    m.morphogens(:,id_top_i) = id_top_p;
    m.morphogens(:,id_side_i) = id_side_p;
    m.morphogens(:,id_distalhalf_i) = id_distalhalf_p;
    m.morphogens(:,id_leftside_i) = id_leftside_p;
    m.morphogens(:,id_sides_i) = id_sides_p;
    m.morphogens(:,id_halfside_i) = id_halfside_p;

%%% USER CODE: FINALISATION

% In this section you may modify the mesh in any way whatsoever.

% If needed force FE to subdivide (increase number FE's) here
% if (Steps(m)==1)
% m = leaf_subdivide( m, 'morphogen','id_subdivision',...
%       'min',0.5,'max',1,...
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
