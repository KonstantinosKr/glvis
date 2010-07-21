# Copyright (c) 2010, Lawrence Livermore National Security, LLC. Produced at the
# Lawrence Livermore National Laboratory. LLNL-CODE-443271. All Rights reserved.
# See file COPYRIGHT for details.
#
# This file is part of the GLVis visualization tool and library. For more
# information and source code availability see http://glvis.googlecode.com.
#
# GLVis is free software; you can redistribute it and/or modify it under the
# terms of the GNU Lesser General Public License (as published by the Free
# Software Foundation) version 2.1 dated February 1999.

CC = g++
OPTS = -O3
DEBUG_OPTS = -g -DGLVIS_DEBUG

# Take screenshots internally with libtiff or externally with xwd?
USE_LIBTIFF = NO
# Link with LAPACK? (needed if MFEM was compiled with LAPACK support)
USE_LAPACK  = NO

# GLVis requires the MFEM library
MFEM_DIR   = ../mfem
MFEM_LIB   = -L$(MFEM_DIR) -lmfem

# LAPACK and BLAS
LAPACK_DIR = $(HOME)/lapack
LAPACK_LIB = -L$(LAPACK_DIR) -llapack
BLAS_DIR   = $(HOME)/lapack
BLAS_LIB   = -L$(LAPACK_DIR) -lblas -lgfortran
# on a Mac:
# BLAS_LIB   = -L$(LAPACK_DIR) -lblas
LAPACK_LIBS_NO  =
LAPACK_LIBS_YES = $(LAPACK_LIB) $(BLAS_LIB)
LAPACK_LIBS     = $(LAPACK_LIBS_$(USE_LAPACK))

# X11 and OpenGL
X11_LIB    = -lX11
GL_DIR     = $(HOME)/mesa
GL_OPTS    = -I/usr/X11R6/include
GL_LIBS    = -L/usr/X11R6/lib -L$(GL_DIR) -lGL -lGLU
# on a Mac:
# GL_LIBS    = -L/usr/X11R6/lib -lGL -lGLU -Wl,-dylib_file,/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGL.dylib:/System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGL.dylib

# libtiff
TIFF_OPTS_YES = -DGLVIS_USE_LIBTIFF -I/sw/include
TIFF_LIBS_YES = -L/sw/lib -ltiff
TIFF_OPTS_NO  =
TIFF_LIBS_NO  =
TIFF_OPTS     = $(TIFF_OPTS_$(USE_LIBTIFF))
TIFF_LIBS     = $(TIFF_LIBS_$(USE_LIBTIFF))

# Targets

COPTS = $(TIFF_OPTS) $(GL_OPTS) $(OPTS)
LIBS  = $(MFEM_LIB) $(LAPACK_LIBS) $(X11_LIB) $(GL_LIBS) $(TIFF_LIBS)

glvis:	glvis.cpp lib/libglvis.a
	$(CC) $(COPTS) -I$(MFEM_DIR) -o glvis glvis.cpp -Llib -lglvis $(LIBS)

debug:
	make "OPTS=$(DEBUG_OPTS)"

lib/libglvis.a: lib/*.hpp lib/*.cpp lib/*.h lib/*.c
	cd lib;	$(CC) $(COPTS) -c -I../$(MFEM_DIR) *.c *.cpp
	cd lib;	ar cruv libglvis.a *.o;	ranlib libglvis.a

clean:
	rm -f lib/*.o lib/*~ *~ glvis lib/libglvis.a GLVis_coloring.gf
