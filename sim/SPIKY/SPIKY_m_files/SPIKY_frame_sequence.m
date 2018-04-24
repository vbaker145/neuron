% This initializes the frame sequence / movie (once the 'Plot' button is pressed and if 'Frame sequence (movie)' is checked).

if ruc==r_para.num_runs % ruc==1
    if get(handles.record_movie_checkbox,'Value')==1
        moviename=[f_para.moviespath,d_para.comment_string,f_para.comment_string,'.avi']
        if exist(moviename,'file')
            clear mex
            delete(moviename)
            %disp([moviename,' deleted!'])
        end
        mov_handles.tmov = avifile(moviename,'fps',f_para.frames_per_second);   % ,'compression','none'
    end

    if f_para.num_instants>0
        mov_handles.mov_line_lh=zeros(1,2);
    end
    if f_para.num_selective_averages>0
        mov_handles.selave_line_lh=zeros(2,max(f_para.num_sel_ave));
    end
    if f_para.num_triggered_averages>0
        mov_handles.trigave_plot_lh=zeros(1,2);
    end
end

%if get(handles.Movie_play_pushbutton,'UserData')==1
%   return;  ###################
%end
set(handles.Movie_play_pushbutton,'UserData',1);
set(handles.Movie_frame_slider,'Min',1)
if f_para.num_frames>1
    set(handles.Movie_frame_slider,'Max',f_para.num_frames)
else
    set(handles.Movie_frame_slider,'Max',2)
end
set(handles.Movie_frame_slider,'UserData',f_para.instants)
set(handles.Movie_first_text,'String',num2str(1))
set(handles.Movie_last_text,'String',num2str(f_para.num_frames))

frc=get(handles.Movie_frame_slider,'Value');
SPIKY_plot_frame    % for a given frc

set(handles.Movie_play_pushbutton,'UserData',0)
setappdata(handles.figure1,'movie_handles',mov_handles)

