# LPNN

This is the source code of the LPNN algorithm (termed LPNN) associated with our IEEE SPL paper:

W. Xiong, C. Schindelhauer, H. C. So, D. J. Schott and S. J. Rupitsch, "Robust TDOA Source Localization Based on Lagrange Programming Neural Network," in IEEE Signal Processing Letters, vol. 28, pp. 1090-1094, 2021, doi: 10.1109/LSP.2021.3082035.

How to call the method? If the MATLAB ode15s solver is to be used, then do the following:

[Time_lca,Outputs_lca] = ode15s(@(Time_lca,Outputs_lca) lpnnlca(Time_lca, Outputs_lca, anc, ri1, rho, thrs1, thrs2, thrs3), tspan, neuron_ini1);           
x_lpnnlca = [Outputs_lca(end,1); Outputs_lca(end,2)];

Here, in the first line there are 8 additional parameters to be specified by the user, i.e., anc, ri1, rho, thrs1, thrs2, thrs3，tspan, and neuron_ini.

anc is a $2 \times L$ matrix, holding the position coordinates for $L$ sensors.

ri1 is a vector of length $(L-1)$, holding the non-redundant TDOA-based range difference measurements.

rho is a positive constant, known as the augmented Lagrangian parameter and can be simply set to 5.

thrs1, thrs2, thrs3 correspond to $\kappa$, $\tau$, $\delta$ in the paper, respectively, which can be set to 1, 1, 1.

tspan = [0:1:somevalue];, where somevalue is the maximum number of time constants set by the user (e.g. 50).

neuron_ini1 is a $(6L) \times 1$ vector, representing the initial values held in the neurons. It can be simply set to rand(6*L, 1).

x_lpnnlca gives the location estimate.

You could use the code for your comparisons at will, as long as the paper above is included as a reference in your manuscript.

If you require any further information, feel free to contact me at w.x.xiong@outlook.com



---Corrigendum for the paper---

The definition of matrix $\bm{D}$ is incorrect. Should be $\bm{D} = \left[ -\bm{1}_{L-1}, \bm{I}_{(L-1)\times (L-1)} \right] \in \mathbb{R}^{(L-1) \times L}$ instead.

In the third line of (3), $\lambda_{2L-1+i}$ should be moved to the outside of the curly bracket.

In the sentence before (3), "by substituting $\bm{e}$ held in the Lagrangian neurons with $\bm{u}$" should be removed. 
